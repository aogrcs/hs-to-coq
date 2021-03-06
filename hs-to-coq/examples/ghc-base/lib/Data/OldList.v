(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

(* Converted imports: *)

Require Coq.Init.Datatypes.
Require Coq.Lists.List.
Require Coq.Program.Basics.
Require Data.Maybe.
Require GHC.Base.
Require GHC.List.
Require GHC.Num.
Require GHC.Prim.
Require GHC.Real.
Require GHC.Tuple.

(* Converted declarations: *)

Definition deleteBy {a} : (a -> a -> bool) -> a -> list a -> list a :=
  fix deleteBy arg_184__ arg_185__ arg_186__
        := match arg_184__ , arg_185__ , arg_186__ with
             | _ , _ , nil => nil
             | eq , x , cons y ys => if eq x y : bool
                                     then ys
                                     else cons y (deleteBy eq x ys)
           end.

Definition deleteFirstsBy {a} : (a -> a -> bool) -> list a -> list a -> list
                                a :=
  fun arg_189__ =>
    match arg_189__ with
      | eq => GHC.Base.foldl (GHC.Base.flip (deleteBy eq))
    end.

Definition delete {a} `{(GHC.Base.Eq_ a)} : a -> list a -> list a :=
  deleteBy GHC.Base.op_zeze__.

Definition op_zrzr__ {a} `{(GHC.Base.Eq_ a)} : list a -> list a -> list a :=
  GHC.Base.foldl (GHC.Base.flip delete).

Infix "\\" := (op_zrzr__) (at level 99).

Notation "'_\\_'" := (op_zrzr__).

Definition dropLength {a} {b} : list a -> list b -> list b :=
  fix dropLength arg_220__ arg_221__
        := match arg_220__ , arg_221__ with
             | nil , y => y
             | _ , nil => nil
             | cons _ x' , cons _ y' => dropLength x' y'
           end.

Definition dropLengthMaybe {a} {b} : list a -> list b -> option (list b) :=
  fix dropLengthMaybe arg_215__ arg_216__
        := match arg_215__ , arg_216__ with
             | nil , y => Some y
             | _ , nil => None
             | cons _ x' , cons _ y' => dropLengthMaybe x' y'
           end.

Definition isSuffixOf {a} `{(GHC.Base.Eq_ a)} : list a -> list a -> bool :=
  fun arg_224__ arg_225__ =>
    match arg_224__ , arg_225__ with
      | ns , hs => GHC.Base.op_zd__ (Data.Maybe.maybe false GHC.Base.id)
                                    (GHC.Base.op_zgzgze__ (dropLengthMaybe ns hs) (fun delta =>
                                                            GHC.Base.op_zd__ GHC.Base.return_ (GHC.Base.op_zeze__ ns
                                                                                                                  (dropLength
                                                                                                                  delta
                                                                                                                  hs))))
    end.

Definition dropWhileEnd {a} : (a -> bool) -> list a -> list a :=
  fun arg_240__ =>
    match arg_240__ with
      | p => GHC.Base.foldr (fun arg_241__ arg_242__ =>
                              match arg_241__ , arg_242__ with
                                | x , xs => if andb (p x) (GHC.List.null xs) : bool
                                            then nil
                                            else cons x xs
                              end) nil
    end.

Definition elem_by {a} : (a -> a -> bool) -> a -> list a -> bool :=
  fix elem_by arg_194__ arg_195__ arg_196__
        := match arg_194__ , arg_195__ , arg_196__ with
             | _ , _ , nil => false
             | eq , y , cons x xs => orb (eq x y) (elem_by eq y xs)
           end.

Definition nubBy {a} : (a -> a -> bool) -> list a -> list a :=
  fun arg_199__ arg_200__ =>
    match arg_199__ , arg_200__ with
      | eq , l => let nubBy' :=
                    fix nubBy' arg_201__ arg_202__
                          := match arg_201__ , arg_202__ with
                               | nil , _ => nil
                               | cons y ys , xs => let j_203__ := cons y (nubBy' ys (cons y xs)) in
                                                   if elem_by eq y xs : bool
                                                   then nubBy' ys xs
                                                   else j_203__
                             end in
                  nubBy' l nil
    end.

Definition nub {a} `{(GHC.Base.Eq_ a)} : list a -> list a :=
  nubBy GHC.Base.op_zeze__.

Definition unionBy {a} : (a -> a -> bool) -> list a -> list a -> list a :=
  fun arg_208__ arg_209__ arg_210__ =>
    match arg_208__ , arg_209__ , arg_210__ with
      | eq , xs , ys => Coq.Init.Datatypes.app xs (GHC.Base.foldl (GHC.Base.flip
                                                                  (deleteBy eq)) (nubBy eq ys) xs)
    end.

Definition union {a} `{(GHC.Base.Eq_ a)} : list a -> list a -> list a :=
  unionBy GHC.Base.op_zeze__.

Definition find {a} : (a -> bool) -> list a -> option a :=
  fun arg_232__ =>
    match arg_232__ with
      | p => Coq.Program.Basics.compose Data.Maybe.listToMaybe (GHC.List.filter p)
    end.

Definition genericDrop {i} {a} `{(GHC.Real.Integral i)} : i -> list a -> list
                                                          a :=
  fix genericDrop arg_103__ arg_104__
        := let j_106__ :=
             match arg_103__ , arg_104__ with
               | _ , nil => nil
               | n , cons _ xs => genericDrop (GHC.Num.op_zm__ n (GHC.Num.fromInteger 1)) xs
             end in
           match arg_103__ , arg_104__ with
             | n , xs => if GHC.Base.op_zlze__ n (GHC.Num.fromInteger 0) : bool
                         then xs
                         else j_106__
           end.

Definition genericLength {i} {a} `{(GHC.Num.Num i)} : list a -> i :=
  fix genericLength arg_123__
        := match arg_123__ with
             | nil => GHC.Num.fromInteger 0
             | cons _ l => GHC.Num.op_zp__ (GHC.Num.fromInteger 1) (genericLength l)
           end.

Definition genericSplitAt {i} {a} `{(GHC.Real.Integral i)} : i -> list a -> list
                                                             a * list a :=
  fix genericSplitAt arg_95__ arg_96__
        := let j_100__ :=
             match arg_95__ , arg_96__ with
               | _ , nil => pair nil nil
               | n , cons x xs => match genericSplitAt (GHC.Num.op_zm__ n (GHC.Num.fromInteger
                                                                        1)) xs with
                                    | pair xs' xs'' => pair (cons x xs') xs''
                                  end
             end in
           match arg_95__ , arg_96__ with
             | n , xs => if GHC.Base.op_zlze__ n (GHC.Num.fromInteger 0) : bool
                         then pair nil xs
                         else j_100__
           end.

Definition genericTake {i} {a} `{(GHC.Real.Integral i)} : i -> list a -> list
                                                          a :=
  fix genericTake arg_109__ arg_110__
        := let j_112__ :=
             match arg_109__ , arg_110__ with
               | _ , nil => nil
               | n , cons x xs => cons x (genericTake (GHC.Num.op_zm__ n (GHC.Num.fromInteger
                                                                       1)) xs)
             end in
           match arg_109__ , arg_110__ with
             | n , _ => if GHC.Base.op_zlze__ n (GHC.Num.fromInteger 0) : bool
                        then nil
                        else j_112__
           end.

Definition insertBy {a} : (a -> a -> comparison) -> a -> list a -> list a :=
  fix insertBy arg_127__ arg_128__ arg_129__
        := match arg_127__ , arg_128__ , arg_129__ with
             | _ , x , nil => cons x nil
             | cmp , x , (cons y ys' as ys) => let scrut_131__ := cmp x y in
                                               match scrut_131__ with
                                                 | Gt => cons y (insertBy cmp x ys')
                                                 | _ => cons x ys
                                               end
           end.

Definition insert {a} `{GHC.Base.Ord a} : a -> list a -> list a :=
  fun arg_137__ arg_138__ =>
    match arg_137__ , arg_138__ with
      | e , ls => insertBy (GHC.Base.compare) e ls
    end.

Definition intersectBy {a} : (a -> a -> bool) -> list a -> list a -> list a :=
  fun arg_178__ arg_179__ arg_180__ =>
    match arg_178__ , arg_179__ , arg_180__ with
      | _ , nil , _ => nil
      | _ , _ , nil => nil
      | eq , xs , ys => Coq.Lists.List.flat_map (fun x =>
                                                  if GHC.List.any (eq x) ys : bool
                                                  then cons x nil
                                                  else nil) xs
    end.

Definition intersect {a} `{(GHC.Base.Eq_ a)} : list a -> list a -> list a :=
  intersectBy GHC.Base.op_zeze__.

Definition isPrefixOf {a} `{(GHC.Base.Eq_ a)} : list a -> list a -> bool :=
  fix isPrefixOf arg_228__ arg_229__
        := match arg_228__ , arg_229__ with
             | nil , _ => true
             | _ , nil => false
             | cons x xs , cons y ys => andb (GHC.Base.op_zeze__ x y) (isPrefixOf xs ys)
           end.

Definition mapAccumL {acc} {x} {y} : (acc -> x -> acc * y) -> acc -> list
                                     x -> acc * list y :=
  fix mapAccumL arg_156__ arg_157__ arg_158__
        := match arg_156__ , arg_157__ , arg_158__ with
             | _ , s , nil => pair s nil
             | f , s , cons x xs => match f s x with
                                      | pair s' y => match mapAccumL f s' xs with
                                                       | pair s'' ys => pair s'' (cons y ys)
                                                     end
                                    end
           end.

Definition mapAccumLF {acc} {x} {y} : (acc -> x -> acc * y) -> x -> (acc -> acc
                                      * list y) -> acc -> acc * list y :=
  fun arg_141__ =>
    match arg_141__ with
      | f => fun arg_142__ arg_143__ =>
               match arg_142__ , arg_143__ with
                 | x , r => GHC.Base.oneShot (fun arg_144__ =>
                                               match arg_144__ with
                                                 | s => match f s x with
                                                          | pair s' y => match r s' with
                                                                           | pair s'' ys => pair s'' (cons y ys)
                                                                         end
                                                        end
                                               end)
               end
    end.

Definition nonEmptySubsequences {a} : list a -> list (list a) :=
  fix nonEmptySubsequences arg_18__
        := match arg_18__ with
             | nil => nil
             | cons x xs => let f :=
                              fun arg_19__ arg_20__ =>
                                match arg_19__ , arg_20__ with
                                  | ys , r => cons ys (cons (cons x ys) r)
                                end in
                            cons (cons x nil) (GHC.Base.foldr f nil (nonEmptySubsequences xs))
           end.

Definition pairWithNil {acc} {y} : acc -> acc * list y :=
  fun arg_153__ => match arg_153__ with | x => pair x nil end.

Definition prependToAll {a} : a -> list a -> list a :=
  fix prependToAll arg_174__ arg_175__
        := match arg_174__ , arg_175__ with
             | _ , nil => nil
             | sep , cons x xs => cons sep (cons x (prependToAll sep xs))
           end.

Definition select {a} : (a -> bool) -> a -> list a * list a -> list a * list
                        a :=
  fun arg_164__ arg_165__ arg_166__ =>
    match arg_164__ , arg_165__ , arg_166__ with
      | p , x , pair ts fs => let j_167__ := pair ts (cons x fs) in
                              if p x : bool
                              then pair (cons x ts) fs
                              else j_167__
    end.

Definition partition {a} : (a -> bool) -> list a -> list a * list a :=
  fun arg_170__ arg_171__ =>
    match arg_170__ , arg_171__ with
      | p , xs => GHC.Base.foldr (select p) (pair nil nil) xs
    end.

Definition strictGenericLength {i} {b} `{(GHC.Num.Num i)} : list b -> i :=
  fun arg_115__ =>
    match arg_115__ with
      | l => let gl :=
               fix gl arg_116__ arg_117__
                     := match arg_116__ , arg_117__ with
                          | nil , a => a
                          | cons _ xs , a => let a' := GHC.Num.op_zp__ a (GHC.Num.fromInteger 1) in
                                             GHC.Prim.seq a' (gl xs a')
                        end in
             gl l (GHC.Num.fromInteger 0)
    end.

Definition stripPrefix {a} `{GHC.Base.Eq_ a} : list a -> list a -> option (list
                                                                          a) :=
  fix stripPrefix arg_235__ arg_236__
        := match arg_235__ , arg_236__ with
             | nil , ys => Some ys
             | cons x xs , cons y ys => if GHC.Base.op_zeze__ x y : bool
                                        then stripPrefix xs ys
                                        else None
             | _ , _ => None
           end.

Definition tailUnwords : GHC.Base.String -> GHC.Base.String :=
  fun arg_8__ => match arg_8__ with | nil => nil | cons _ xs => xs end.

Definition tails {a} : list a -> list (list a) :=
  fun arg_25__ =>
    match arg_25__ with
      | lst => GHC.Base.build (fun arg_26__ arg_27__ =>
                                match arg_26__ , arg_27__ with
                                  | c , n => let tailsGo :=
                                               fix tailsGo arg_28__
                                                     := match arg_28__ with
                                                          | xs => c xs (match xs with
                                                                      | nil => n
                                                                      | cons _ xs' => tailsGo xs'
                                                                    end)
                                                        end in
                                             tailsGo lst
                                end)
    end.

Definition unwords : list GHC.Base.String -> GHC.Base.String :=
  fun arg_10__ =>
    match arg_10__ with
      | nil => GHC.Base.hs_string__ ""
      | cons w ws => let go :=
                       fix go arg_12__
                             := match arg_12__ with
                                  | nil => GHC.Base.hs_string__ ""
                                  | cons v vs => cons (GHC.Char.hs_char__ " ") (Coq.Init.Datatypes.app v (go vs))
                                end in
                     Coq.Init.Datatypes.app w (go ws)
    end.

Definition unwordsFB : GHC.Base.String -> GHC.Base.String -> GHC.Base.String :=
  fun arg_4__ arg_5__ =>
    match arg_4__ , arg_5__ with
      | w , r => cons (GHC.Char.hs_char__ " ") (Coq.Init.Datatypes.app w r)
    end.

Definition unzip4 {a} {b} {c} {d} : list (a * b * c * d) -> list a * list b *
                                    list c * list d :=
  GHC.Base.foldr (fun arg_52__ arg_53__ =>
                   match arg_52__ , arg_53__ with
                     | pair (pair (pair a b) c) d , pair (pair (pair as_ bs) cs) ds => pair (pair
                                                                                            (pair (cons a as_) (cons b
                                                                                                                     bs))
                                                                                            (cons c cs)) (cons d ds)
                   end) (pair (pair (pair nil nil) nil) nil).

Definition unzip5 {a} {b} {c} {d} {e} : list (a * b * c * d * e) -> list a *
                                        list b * list c * list d * list e :=
  GHC.Base.foldr (fun arg_47__ arg_48__ =>
                   match arg_47__ , arg_48__ with
                     | pair (pair (pair (pair a b) c) d) e , pair (pair (pair (pair as_ bs) cs) ds)
                                                                  es => pair (pair (pair (pair (cons a as_) (cons b bs))
                                                                                         (cons c cs)) (cons d ds)) (cons
                                                                             e es)
                   end) (pair (pair (pair (pair nil nil) nil) nil) nil).

Definition unzip6 {a} {b} {c} {d} {e} {f} : list (a * b * c * d * e * f) -> list
                                            a * list b * list c * list d * list e * list f :=
  GHC.Base.foldr (fun arg_42__ arg_43__ =>
                   match arg_42__ , arg_43__ with
                     | pair (pair (pair (pair (pair a b) c) d) e) f , pair (pair (pair (pair (pair
                                                                                             as_ bs) cs) ds) es) fs =>
                       pair (pair (pair (pair (pair (cons a as_) (cons b bs)) (cons c cs)) (cons d ds))
                                  (cons e es)) (cons f fs)
                   end) (pair (pair (pair (pair (pair nil nil) nil) nil) nil) nil).

Definition unzip7 {a} {b} {c} {d} {e} {f} {g} : list (a * b * c * d * e * f *
                                                     g) -> list a * list b * list c * list d * list e * list f * list
                                                g :=
  GHC.Base.foldr (fun arg_37__ arg_38__ =>
                   match arg_37__ , arg_38__ with
                     | pair (pair (pair (pair (pair (pair a b) c) d) e) f) g , pair (pair (pair (pair
                                                                                                (pair (pair as_ bs) cs)
                                                                                                ds) es) fs) gs => pair
                                                                                                                  (pair
                                                                                                                  (pair
                                                                                                                  (pair
                                                                                                                  (pair
                                                                                                                  (pair
                                                                                                                  (cons
                                                                                                                  a as_)
                                                                                                                  (cons
                                                                                                                  b bs))
                                                                                                                  (cons
                                                                                                                  c cs))
                                                                                                                  (cons
                                                                                                                  d ds))
                                                                                                                  (cons
                                                                                                                  e es))
                                                                                                                  (cons
                                                                                                                  f fs))
                                                                                                                  (cons
                                                                                                                  g gs)
                   end) (pair (pair (pair (pair (pair (pair nil nil) nil) nil) nil) nil) nil).

Definition zipWith4 {a} {b} {c} {d} {e} : (a -> b -> c -> d -> e) -> list
                                          a -> list b -> list c -> list d -> list e :=
  fix zipWith4 arg_84__ arg_85__ arg_86__ arg_87__ arg_88__
        := match arg_84__ , arg_85__ , arg_86__ , arg_87__ , arg_88__ with
             | z , cons a as_ , cons b bs , cons c cs , cons d ds => cons (z a b c d)
                                                                          (zipWith4 z as_ bs cs ds)
             | _ , _ , _ , _ , _ => nil
           end.

Definition zip4 {a} {b} {c} {d} : list a -> list b -> list c -> list d -> list
                                  (a * b * c * d) :=
  zipWith4 GHC.Tuple.op_Z4T__.

Definition zipWith5 {a} {b} {c} {d} {e} {f}
    : (a -> b -> c -> d -> e -> f) -> list a -> list b -> list c -> list d -> list
      e -> list f :=
  fix zipWith5 arg_76__ arg_77__ arg_78__ arg_79__ arg_80__ arg_81__
        := match arg_76__ , arg_77__ , arg_78__ , arg_79__ , arg_80__ , arg_81__ with
             | z , cons a as_ , cons b bs , cons c cs , cons d ds , cons e es => cons (z a b
                                                                                      c d e) (zipWith5 z as_ bs cs ds
                                                                                      es)
             | _ , _ , _ , _ , _ , _ => nil
           end.

Definition zip5 {a} {b} {c} {d} {e} : list a -> list b -> list c -> list
                                      d -> list e -> list (a * b * c * d * e) :=
  zipWith5 GHC.Tuple.op_Z5T__.

Definition zipWith6 {a} {b} {c} {d} {e} {f} {g}
    : (a -> b -> c -> d -> e -> f -> g) -> list a -> list b -> list c -> list
      d -> list e -> list f -> list g :=
  fix zipWith6 arg_67__ arg_68__ arg_69__ arg_70__ arg_71__ arg_72__ arg_73__
        := match arg_67__
               , arg_68__
               , arg_69__
               , arg_70__
               , arg_71__
               , arg_72__
               , arg_73__ with
             | z , cons a as_ , cons b bs , cons c cs , cons d ds , cons e es , cons f fs =>
               cons (z a b c d e f) (zipWith6 z as_ bs cs ds es fs)
             | _ , _ , _ , _ , _ , _ , _ => nil
           end.

Definition zip6 {a} {b} {c} {d} {e} {f} : list a -> list b -> list c -> list
                                          d -> list e -> list f -> list (a * b * c * d * e * f) :=
  zipWith6 GHC.Tuple.op_Z6T__.

Definition zipWith7 {a} {b} {c} {d} {e} {f} {g} {h}
    : (a -> b -> c -> d -> e -> f -> g -> h) -> list a -> list b -> list c -> list
      d -> list e -> list f -> list g -> list h :=
  fix zipWith7 arg_57__ arg_58__ arg_59__ arg_60__ arg_61__ arg_62__ arg_63__
               arg_64__
        := match arg_57__
               , arg_58__
               , arg_59__
               , arg_60__
               , arg_61__
               , arg_62__
               , arg_63__
               , arg_64__ with
             | z , cons a as_ , cons b bs , cons c cs , cons d ds , cons e es , cons f fs ,
               cons g gs => cons (z a b c d e f g) (zipWith7 z as_ bs cs ds es fs gs)
             | _ , _ , _ , _ , _ , _ , _ , _ => nil
           end.

Definition zip7 {a} {b} {c} {d} {e} {f} {g} : list a -> list b -> list c -> list
                                              d -> list e -> list f -> list g -> list (a * b * c * d * e * f * g) :=
  zipWith7 GHC.Tuple.op_Z7T__.

Inductive SnocBuilder a : Type := Mk_SnocBuilder : GHC.Num.Word -> list
                                                   a -> list a -> SnocBuilder a.

Arguments Mk_SnocBuilder {_} _ _ _.

Definition toListSB {a} : SnocBuilder a -> list a :=
  fun arg_0__ =>
    match arg_0__ with
      | Mk_SnocBuilder _ f r => Coq.Init.Datatypes.app f (GHC.List.reverse r)
    end.

Definition emptySB {a} : SnocBuilder a :=
  Mk_SnocBuilder (GHC.Num.fromInteger 0) nil nil.

(* Unbound variables:
     * Coq.Init.Datatypes.app Coq.Lists.List.flat_map Coq.Program.Basics.compose
     Data.Maybe.listToMaybe Data.Maybe.maybe GHC.Base.Eq_ GHC.Base.Ord
     GHC.Base.String GHC.Base.build GHC.Base.compare GHC.Base.flip GHC.Base.foldl
     GHC.Base.foldr GHC.Base.id GHC.Base.oneShot GHC.Base.op_zd__ GHC.Base.op_zeze__
     GHC.Base.op_zgzgze__ GHC.Base.op_zlze__ GHC.Base.return_ GHC.List.any
     GHC.List.filter GHC.List.null GHC.List.reverse GHC.Num.Num GHC.Num.Word
     GHC.Num.op_zm__ GHC.Num.op_zp__ GHC.Prim.seq GHC.Real.Integral
     GHC.Tuple.op_Z4T__ GHC.Tuple.op_Z5T__ GHC.Tuple.op_Z6T__ GHC.Tuple.op_Z7T__ None
     Some andb bool comparison cons false list nil option orb pair true
*)
