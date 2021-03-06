{-# LANGUAGE LambdaCase, RecordWildCards, OverloadedStrings, OverloadedLists, FlexibleContexts, ScopedTypeVariables #-}

module HsToCoq.ConvertHaskell.Pattern (
  convertPat,  convertLPat,
  -- * Utility
  Refutability(..), refutability, refutabilityMult, isRefutable, isConstructor, isSoleConstructor,

  PatternSummary(..), patternSummary, multPatternSummary,
  isUnderscoreMultPattern,
  mutExcl, mutExcls,
  isCompleteMultiPattern,
) where

import Control.Lens hiding ((<|))

import Data.Maybe
import Data.Traversable
import Data.List.NonEmpty (NonEmpty(..), (<|), toList)
import qualified Data.Text as T

import Control.Monad.Trans.Maybe
import Control.Monad.Writer
import Control.Monad.State

import qualified Data.Map.Strict as M

import GHC hiding (Name, HsChar, HsString)
import qualified GHC
import HsToCoq.Util.GHC.FastString

import HsToCoq.Util.GHC
import HsToCoq.Util.GHC.HsExpr
import HsToCoq.Coq.Gallina as Coq
import HsToCoq.Coq.Gallina.Util as Coq

import HsToCoq.ConvertHaskell.Parameters.Edits
import HsToCoq.ConvertHaskell.Monad
import HsToCoq.ConvertHaskell.Variables
import HsToCoq.ConvertHaskell.Literals
import HsToCoq.ConvertHaskell.InfixNames

--------------------------------------------------------------------------------

convertPat :: (ConversionMonad m, MonadWriter [Term] m) => Pat GHC.Name -> m Pattern
convertPat (WildPat PlaceHolder) =
  pure UnderscorePat

convertPat (GHC.VarPat (L _ x)) =
  Coq.VarPat <$> freeVar x

convertPat (LazyPat p) = do
  p' <- convertLPat p
  r <- refutability p'
  if isRefutable r then convUnsupported "lazy refutable pattern"
                   else return p'

convertPat (GHC.AsPat x p) =
  Coq.AsPat <$> convertLPat p <*> freeVar (unLoc x)

convertPat (ParPat p) =
  convertLPat p

convertPat (BangPat p) =
  convertLPat p

convertPat (ListPat pats PlaceHolder overloaded) =
  if maybe True (isNoSyntaxExpr . snd) overloaded
  then foldr (App2Pat (Bare "cons")) (Coq.VarPat "nil") <$> traverse convertLPat pats
  else convUnsupported "overloaded list patterns"

-- TODO: Mark converted unboxed tuples specially?
convertPat (TuplePat pats _boxity _PlaceHolders) =
  foldl1 (App2Pat (Bare "pair")) <$> traverse convertLPat pats

convertPat (PArrPat _ _) =
  convUnsupported "parallel array patterns"

convertPat (ConPatIn (L _ hsCon) conVariety) = do
  con <- var ExprNS hsCon

  case conVariety of
    PrefixCon args ->
      appListPat (Bare con) <$> traverse convertLPat args

    RecCon HsRecFields{..} ->
      let recPatUnsupported what = do
            hsConStr <- ghcPpr hsCon
            convUnsupported $  "using a record pattern for the "
                            ++ what ++ " constructor `" ++ T.unpack hsConStr ++ "'"

      in use (constructorFields . at con) >>= \case
           Just (RecordFields conFields) -> do
             let defaultPat field | isJust rec_dotdot = Coq.VarPat field
                                  | otherwise         = UnderscorePat

             patterns <- fmap M.fromList . for rec_flds $ \(L _ (HsRecField (L _ (FieldOcc (L _ hsField) _)) hsPat pun)) -> do
                           field <- recordField hsField
                           pat   <- if pun
                                    then pure $ Coq.VarPat field
                                    else convertLPat hsPat
                           pure (field, pat)
             pure . appListPat (Bare con)
                  $ map (\field -> M.findWithDefault (defaultPat field) field patterns) conFields

           Just (NonRecordFields count)
             | null rec_flds && isNothing rec_dotdot ->
               pure . appListPat (Bare con) $ replicate count UnderscorePat

             | otherwise ->
               recPatUnsupported "non-record"

           Nothing -> recPatUnsupported "unknown"

    InfixCon l r -> do
      App2Pat (Bare (toPrefix con)) <$> convertLPat l <*> convertLPat r

convertPat (ConPatOut{}) =
  convUnsupported "[internal?] `ConPatOut' constructor"

convertPat (ViewPat _ _ _) =
  convUnsupported "view patterns"

convertPat (SplicePat _) =
  convUnsupported "pattern splices"

convertPat (LitPat lit) =
  case lit of
    GHC.HsChar   _ c       -> pure $ InScopePat (StringPat $ T.singleton c) "char"
    HsCharPrim   _ _       -> convUnsupported "`Char#' literal patterns"
    GHC.HsString _ fs      -> pure . StringPat $ fsToText fs
    HsStringPrim _ _       -> convUnsupported "`Addr#' literal patterns"
    HsInt        _ int     -> convertIntegerPat "`Integer' literal patterns" int
    HsIntPrim    _ int     -> convertIntegerPat "`Integer' literal patterns" int
    HsWordPrim   _ _       -> convUnsupported "`Word#' literal patterns"
    HsInt64Prim  _ _       -> convUnsupported "`Int64#' literal patterns"
    HsWord64Prim _ _       -> convUnsupported "`Word64#' literal patterns"
    HsInteger    _ int _ty -> convertIntegerPat "`Integer' literal patterns" int
    HsRat        _ _       -> convUnsupported "`Rational' literal patterns"
    HsFloatPrim  _         -> convUnsupported "`Float#' literal patterns"
    HsDoublePrim _         -> convUnsupported "`Double#' literal patterns"

convertPat (NPat (L _ OverLit{..}) _negate _eq PlaceHolder) = -- And strings
  case ol_val of
    HsIntegral   _src int -> convertIntegerPat "integer literal patterns" int
    HsFractional _        -> convUnsupported "fractional literal patterns"
    HsIsString   _src str -> pure . StringPat $ fsToText str

convertPat (NPlusKPat _ _ _ _ _ _) =
  convUnsupported "n+k-patterns"

convertPat (SigPatIn _ _) =
  convUnsupported "`SigPatIn' constructor"

convertPat (SigPatOut _ _) =
  convUnsupported "`SigPatOut' constructor"

convertPat (CoPat _ _ _) =
  convUnsupported "coercion patterns"

--------------------------------------------------------------------------------

convertLPat :: (ConversionMonad m, MonadWriter [Term] m) => LPat GHC.Name -> m Pattern
convertLPat = convertPat . unLoc

--------------------------------------------------------------------------------

convertIntegerPat :: (ConversionMonad m, MonadWriter [Term] m)
                  => String -> Integer -> m Pattern
convertIntegerPat what hsInt = do
  var <- gensym "num"
  int <- convertInteger what hsInt
  Coq.VarPat var <$ tell ([Infix (Var var) "==" (PolyNum int)] :: [Term])

isConstructor :: MonadState ConversionState m => Ident -> m Bool
isConstructor con = isJust <$> (use $ constructorTypes . at con)

-- Nothing:    Not a constructor
-- Just True:  Sole constructor
-- Just False: One of many constructors
isSoleConstructor :: ConversionMonad m => Ident -> m (Maybe Bool)
isSoleConstructor con = runMaybeT $ do
  ty    <- MaybeT . use $ constructorTypes . at con
  ctors <-          use $ constructors     . at ty
  pure $ length (fromMaybe [] ctors) == 1

data Refutability = Trivial (Maybe Ident) -- Variables (with `Just`), underscore (with `Nothing`)
                  | SoleConstructor       -- (), (x,y)
                  | Refutable             -- Nothing, Right x, (3,_)
                  deriving (Eq, Ord, Show, Read)

isRefutable :: Refutability -> Bool
isRefutable Refutable = True 
isRefutable _ = False

-- Module-local
constructor_refutability :: ConversionMonad m => Qualid -> NonEmpty Pattern -> m Refutability
constructor_refutability con args =
  isSoleConstructor (qualidToIdent con) >>= \case
    Nothing    -> pure Refutable -- Error
    Just True  -> maximum . (SoleConstructor <|) <$> traverse refutability args
    Just False -> pure Refutable

refutabilityMult :: ConversionMonad m => MultPattern -> m Refutability
refutabilityMult (MultPattern pats) =
    maximum . (SoleConstructor <|) <$> traverse refutability pats

refutability :: ConversionMonad m => Pattern -> m Refutability
refutability (ArgsPat con args)         = constructor_refutability con args
refutability (ExplicitArgsPat con args) = constructor_refutability con args
refutability (InfixPat arg1 con arg2)   = constructor_refutability (Bare con) [arg1,arg2]
refutability (Coq.AsPat pat _)          = refutability pat
refutability (InScopePat _ _)           = pure Refutable -- TODO: Handle scopes
refutability (QualidPat qid)            = let name = qualidToIdent qid
                                          in isSoleConstructor name <&> \case
                                               Nothing    -> Trivial $ Just name
                                               Just True  -> SoleConstructor
                                               Just False -> Refutable
refutability UnderscorePat              = pure $ Trivial Nothing
refutability (NumPat _)                 = pure Refutable
refutability (StringPat _)              = pure Refutable
refutability (OrPats _)                 = pure Refutable -- TODO: Handle or-patterns?

-- This turns a Pattern into a summary that contains just enough information
-- to determine disjointness of patterns
--
-- It is ok to err on the side of OtherSummary.
-- For example, OrPatterns are considered OtherSummary
data PatternSummary = OtherSummary | ConApp Ident [PatternSummary]
  deriving Show

patternSummary :: MonadState ConversionState m => Pattern -> m PatternSummary
patternSummary (ArgsPat con args)         = ConApp name <$> mapM patternSummary (toList args)
  where name = qualidToIdent con
patternSummary (ExplicitArgsPat con args) = ConApp name <$> mapM patternSummary (toList args)
  where name = qualidToIdent con
patternSummary (InfixPat arg1 con arg2)   = ConApp con <$> mapM patternSummary [arg1, arg2]
patternSummary (Coq.AsPat pat _)          = patternSummary pat
patternSummary (InScopePat pat _)         = patternSummary pat
patternSummary (QualidPat qid)            = isConstructor name <&> \case
    True -> ConApp name []
    False -> OtherSummary
  where name = qualidToIdent qid
patternSummary UnderscorePat              = pure OtherSummary
patternSummary (NumPat _)                 = pure OtherSummary
patternSummary (StringPat _)              = pure OtherSummary
patternSummary (OrPats _)                 = pure OtherSummary

multPatternSummary :: MonadState ConversionState m => MultPattern -> m [PatternSummary]
multPatternSummary (MultPattern pats) = mapM patternSummary (toList pats)

mutExcls :: [PatternSummary] -> [PatternSummary] -> Bool
mutExcls pats1 pats2 = or $ zipWith mutExcl pats1 pats2

mutExcl :: PatternSummary -> PatternSummary -> Bool
mutExcl (ConApp con1 args1) (ConApp con2 args2)
    = con1 /= con2 || mutExcls args1 args2
mutExcl _ _ = False


-- A simple completeness checker. Traverses the list of patterns, and keep
-- tracks of all pattern summaries that we still need to match
-- Internally, we use OtherSummary as “everything yet has to match” 
type Missing = [PatternSummary]
type Missings = [Missing]

isCompleteMultiPattern :: forall m. MonadState ConversionState m =>
    [MultPattern] -> m Bool
isCompleteMultiPattern [] = pure True -- Maybe an empty data type?
isCompleteMultiPattern mpats = null <$> goGroup mpats
  where
    -- Initially, we miss everything
    initMissings = [[]]

    goGroup :: [MultPattern] -> m Missings
    goGroup = foldM goMP initMissings

    goMP :: Missings -> MultPattern -> m Missings
    goMP missings mpats = multPatternSummary mpats >>= goPatsSet missings

    goPatsSet :: Missings -> [PatternSummary] -> m Missings
    goPatsSet missingSet pats = concat <$> mapM (\missing -> gos missing pats) missingSet

    -- Combinding an conjunction of patterns
    gos :: Missing -> [PatternSummary] -> m Missings
    gos _ [] = pure []
    gos [] pats = gos [OtherSummary] pats
    gos (m:missings) (p:pats) = do
        m' <- go m p
        missings' <- gos missings pats
        pure $ combineMissingsWith (:) m missings m' missings'

    -- A single pattern
    go :: PatternSummary -> PatternSummary -> m Missing
    -- The pattern handles all cases
    go _ OtherSummary = pure []
    -- The pattern applies only partially. Split the input and recurse.
    go OtherSummary p@(ConApp con _) =
        fromMaybe [] <$> runMaybeT (do
           ty    <- MaybeT . use $ constructorTypes . at con
           ctors <- MaybeT . use $ constructors     . at ty
           -- Re-run the process with a separate Missing for each constructor
           lift $ concat <$> mapM (\ctor -> go (ConApp ctor []) p) ctors
        )
        -- What if we do not know this constructor? Just assume it is
        -- completeness for now
    go m@(ConApp con1 args1) (ConApp con2 args2)
        -- The pattern applies, so the missing is restricted
        -- to what’s left by the arguments, and what’s left to be done
        | con1 == con2 = (ConApp con1 `map`) <$> gos args1 args2
        -- The pattern does not apply, so the missing is unchanged
        | otherwise    = pure [m]

combineMissingsWith :: (a -> b -> c) -> a -> b -> [a] -> [b] -> [c]
combineMissingsWith f a b as bs = ((`f`b) <$> as) ++ ((a`f`) <$> bs)
-- this is the Applicative instance of Succs -- who would have thought
-- I wonder if the code above would be simpler when written with some sort
-- of SuccsT m

isUnderscoreMultPattern :: MultPattern -> Bool
isUnderscoreMultPattern (MultPattern pats) = all isUnderscoreCoq pats

isUnderscoreCoq :: Pattern -> Bool
isUnderscoreCoq UnderscorePat = True
isUnderscoreCoq _ = False
