Require Import Bag.
Require Import WellFormed.

Require Import Proofs.GHC.Base.
Require Import Proofs.GHC.List.
Require Import Proofs.Data.Foldable.
Require Import Proofs.Data.OldList.

Require Import Coq.Lists.List.
Import ListNotations.
Require Import ListUtils.
Require Import Coq.ZArith.ZArith.

From mathcomp Require Import ssreflect ssrfun ssrbool.
Set Bullet Behavior "Strict Subproofs".

(***** Universal quantification over bags ****)

(* See `all_bag_ok`, below *)

(***** Bag correctness theorems *****)

Lemma bagToList_ListBag {A} (xs : list A) :
  bagToList (Mk_ListBag xs) = xs.
Proof.
  by case: xs => * //=; rewrite /bagToList /= hs_coq_foldr_list' fold_right_cons_nil.
Qed.

Theorem foldrBag_ok {A R} (f : A -> R -> R) (z : R) (b : Bag A) :
  foldrBag f z b = fold_right f z (bagToList b).
Proof.
  elim: b R f z => [|x | l IHl r IHr | xs] //= R f z.
  - rewrite /bagToList /=.
    rewrite (IHr _ cons []) fold_right_cons_nil.
    rewrite !IHl IHr.
    by rewrite -fold_right_app fold_right_cons.
  - by rewrite bagToList_ListBag hs_coq_foldr_list'.
Qed.

Lemma bagToList_TwoBags {A} (l r : Bag A) :
  bagToList (Mk_TwoBags l r) = bagToList l ++ bagToList r.
Proof.
  by rewrite /bagToList //= !foldrBag_ok !fold_right_cons_nil !fold_right_cons.
Qed.

Theorem unitBag_ok {A} (x : A) :
  bagToList (unitBag x) = [ x ].
Proof. reflexivity. Qed.

(* Not from GHC, but should one day be replaced with `allBag_ok` – see
   WellFormed.v *)
Theorem all_bag_ok {A} (p : A -> bool) (b : Bag A) :
  all_bag p b = all p (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - by rewrite andbT.
  - by rewrite bagToList_TwoBags all_app IHl IHr.
  - by rewrite bagToList_ListBag.
Qed.

Theorem unionBags_ok {A} (b1 b2 : Bag A) :
  bagToList (unionBags b1 b2) = bagToList b1 ++ bagToList b2.
Proof. by case: b1 => *; case: b2 => *; rewrite -bagToList_TwoBags. Qed.

Theorem unionManyBags_ok {A} (bs : list (Bag A)) :
  bagToList (unionManyBags bs) = concat (map bagToList bs).
Proof.
  rewrite /unionManyBags; elim: bs => [|b bs IH] //=.
  by rewrite unionBags_ok IH.
Qed.

Theorem snocBag_ok {A} (b : Bag A) (x : A) :
  bagToList (snocBag b x) = bagToList b ++ [x].
Proof. by rewrite /snocBag unionBags_ok unitBag_ok. Qed.

Theorem mapBag_ok {A B} (f : A -> B) (b : Bag A) :
  bagToList (mapBag f b) = map f (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - by rewrite !bagToList_TwoBags map_app IHl IHr.
  - by rewrite !bagToList_ListBag hs_coq_map.
Qed.

(* TODO mapBagM mapBagM_ mapAndUnzipBagM *)

Theorem bagToList_listToBag {A} (l : list A) :
  bagToList (listToBag l) = l.
Proof. by case: l => * //=; rewrite bagToList_ListBag. Qed.

(* Is there a partial inverse theorem?  The direct inverse isn't true because
   there are multiple equivalent bags -- for example, `ListBag [x]` and
   `UnitBag x`. *)

Theorem partitionBag_ok {A} (p : A -> bool) (b : Bag A) :
  let: (bt, bf) := partitionBag p b
  in (bagToList bt, bagToList bf) = partition p (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - by case: (p x).
  - move: (partition_app p (bagToList l) (bagToList r)).
    case: (partitionBag p l) IHl => [lt lf] <-; case: (partitionBag p r) IHr => [rt rf] <-.
    rewrite !unionBags_ok bagToList_TwoBags.
    by case: (partition p (_ ++ _)) => [t f] [-> ->].
  - rewrite hs_coq_partition bagToList_ListBag.
    by case: (partition p xs) => *; rewrite !bagToList_listToBag.
Qed.

Theorem lengthBag_ok {A} (b : Bag A) :
  lengthBag b = Zlength (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - by rewrite bagToList_TwoBags Zlength_app IHl IHr.
  - by rewrite hs_coq_length_list' bagToList_ListBag.
Qed.

Theorem isEmptyBag_ok {A} (b : Bag A) :
  well_formed_bag b ->
  isEmptyBag b = null (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - rewrite eval_wf_TwoBags => /and4P [nel ner wfl wfr] *.
    rewrite bagToList_TwoBags app_null.
    by rewrite -IHl // -IHr // (negbTE nel).
  - by case: xs.
Qed.

Theorem foldlBag_ok {A R} (f : R -> A -> R) (z : R) (b : Bag A) :
  foldlBag f z b = fold_left f (bagToList b) z.
Proof.
  elim: b z => [|x | l IHl r IHr | xs] //= z.
  - by rewrite bagToList_TwoBags fold_left_app IHl IHr.
  - by rewrite bagToList_ListBag hs_coq_foldl_list'.
Qed.

(* TODO foldrBagM foldlBagM *)

Theorem foldBag_ok {A R} (f : R -> R -> R) (u : A -> R) (z : R) (b : Bag A) :
  associative f ->
  foldBag f u z b = fold_right f z (map u (bagToList b)).
Proof.
  move=> f_assoc.
  elim: b z => [| x | l IHl r IHr | xs] //= z; rewrite /bagToList /=.
  - rewrite !foldrBag_ok fold_right_cons_nil fold_right_cons.
    by rewrite IHl IHr  -fold_right_app map_app.
  - by rewrite !hs_coq_foldr_list' fold_right_cons_nil fold_right_map.
Qed.

(* TODO flatMapBagM flatMapBagPairM *)

Theorem filterBag_ok {A} (p : A -> bool) (b : Bag A) :
  bagToList (filterBag p b) = filter p (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - by case: (p x).
  - by rewrite unionBags_ok bagToList_TwoBags filter_app IHl IHr.
  - by rewrite bagToList_listToBag bagToList_ListBag hs_coq_filter.
Qed.

(* TODO filterBagM *)

Theorem emptyBag_ok {A} : bagToList (@Mk_EmptyBag A) = [].
Proof. reflexivity. Qed.

Theorem elemBag_ok {A} `{GHC.Base.Eq_ A} (x : A) (b : Bag A) :
  elemBag x b = any (GHC.Base.op_zeze__ x) (bagToList b).
Proof.
  elim: b => [| y | l IHl r IHr | ys] //=.
  - by rewrite orbF.
  - by rewrite bagToList_TwoBags any_app IHl IHr.
  - by rewrite bagToList_ListBag hs_coq_any_list (any_ext _ (GHC.Base.op_zeze__ x)).
Qed.

Corollary elemBag_eq_ok {A} `{EqExact A} (x : A) (b : Bag A) :
  elemBag x b <-> In x (bagToList b).
Proof.
  rewrite elemBag_ok; symmetry; apply rwP.
  eapply equivP; first by apply anyP.
  etransitivity; first by apply Exists_exists.
  elim: (bagToList b) => [|y ys IH] /=; split => //=.
  - by move=> [] ? [].
  - by move => [z [? /Eq_eq ->]].
  - move=> IN; exists x; split; last by apply/Eq_eq.
    by case: IN => [-> | ?]; [left | right].
Qed.        

Theorem consBag_ok {A} (x : A) (b : Bag A) :
  bagToList (consBag x b) = x :: bagToList b.
Proof. elim: b => //. Qed.

Theorem concatBag_ok {A} (bb : Bag (Bag A)) :
  bagToList (concatBag bb) = concat (map bagToList (bagToList bb)).
Proof.
  rewrite /concatBag foldrBag_ok.
  elim: (bagToList bb) => [|b bs IH] //=.
  by rewrite unionBags_ok IH.
Qed.

Theorem catBagMaybes_ok {A} (b : Bag (option A)) :
  bagToList (catBagMaybes b) =
  flat_map (fun o => match o with Some x => [x] | None => [] end) (bagToList b).
Proof.
  rewrite /catBagMaybes foldrBag_ok.
  elim: (bagToList b) => [|[x|] xs IH] //=.
  by rewrite consBag_ok IH.
Qed.

Theorem anyBag_ok {A} (p : A -> bool) (b : Bag A) :
  anyBag p b = any p (bagToList b).
Proof.
  elim: b => [| x | l IHl r IHr | xs] //=.
  - by rewrite orbF.
  - by rewrite bagToList_TwoBags any_app IHl IHr.
  - by rewrite bagToList_ListBag hs_coq_any_list.
Qed.

(* TODO anyBagM *)

Require Data.Traversable.
Import GHC.Base.
Import Data.Functor.

Infix "<$>" := Data.Functor.op_zlzdzg__ : NEW_scope.
Infix "<*>" := GHC.Base.op_zlztzg__ : NEW_scope.
Infix ">>=" := GHC.Base.op_zgzgze__ : NEW_scope.
Open Scope NEW_scope.

Require Import Coq.Logic.FunctionalExtensionality.

(* Like the "extensionality" tactic, but doesn't intro -- nicer with ssreflect *)
Ltac funext :=
  match goal with
    [ |- ?X = ?Y ] =>
    (apply (@functional_extensionality _ _ X Y) ||
     apply (@functional_extensionality_dep _ _ X Y) ||
     apply forall_extensionalityP ||
     apply forall_extensionalityS ||
     apply forall_extensionality)
  end.


Theorem mapMBag_ok {M A B} `{MonadLaws M} (f : A -> M B) (b : Bag A) :
  GHC.Base.fmap bagToList (mapBagM f b) = Data.Traversable.traverse f (bagToList b).
Proof.
  rewrite /Data.Traversable.traverse /= /Data.Traversable.instance_Traversable_list_traverse.
  replace (fmap bagToList (mapBagM f b)) with
          (_++_ <$> (fmap bagToList (mapBagM f b)) <*> pure [])
          by by unfold "<$>";
                rewrite functor_composition !applicative_fmap applicative_interchange
                        -applicative_composition !applicative_homomorphism;
                do 2 f_equal; funext=> ?; unfold "∘"; rewrite app_nil_r.
  generalize (pure ([] : list B)) => z.
  elim: b z => [| x | l IHl r IHr | xs] z //=.
  - rewrite applicative_fmap -monad_applicative_pure applicative_homomorphism.
    unfold "<$>"; rewrite applicative_fmap applicative_homomorphism.
    replace [eta app _] with (@GHC.Base.id (list B)) by by funext.
    apply applicative_identity.
  - unfold "<$>"; rewrite
      !applicative_fmap !monad_applicative_ap /ap !monad_applicative_pure !monad_left_id
      -!monad_composition.
    by f_equal; funext => ?; rewrite !monad_left_id.
  - rewrite bagToList_TwoBags hs_coq_foldr_base fold_right_app -!hs_coq_foldr_base.
    rewrite -IHr -IHl.
    unfold "<$>"; rewrite
      !functor_composition !applicative_fmap
      !monad_applicative_ap /ap !monad_applicative_pure !monad_left_id -!monad_composition.
    f_equal; funext=> ?.
    rewrite !monad_left_id -!monad_composition.
    f_equal; funext=> ?.
    rewrite !monad_left_id -!monad_composition.
    f_equal; funext=> ?.
    rewrite monad_left_id.
    f_equal.
    by unfold "∘"; rewrite /= bagToList_TwoBags app_assoc.
  - rewrite bagToList_ListBag
            /Data.Traversable.instance_Traversable_list_mapM
            /Data.Traversable.instance_Traversable_list_traverse.
    unfold "<$>"; rewrite
      functor_composition applicative_fmap
      !monad_applicative_ap /ap monad_applicative_pure monad_left_id.
    rewrite -!monad_composition.

    elim: xs z => [|x xs IH] z /=.
    + rewrite monad_applicative_pure !monad_left_id.
      replace (fun _ : list B => return_ _) with (return_ : list B -> M (list B));
        first by apply monad_right_id.
      by funext.
    + rewrite -(IH z).
      rewrite !applicative_fmap !monad_applicative_ap /ap monad_applicative_pure
              !monad_left_id -!monad_composition.
      f_equal; funext=> ?.
      rewrite !monad_left_id -!monad_composition.
      f_equal; funext=> ?.
      rewrite -!monad_composition !monad_left_id -!monad_composition.
      f_equal; funext=> ?.
      by rewrite !monad_left_id.
Qed.
