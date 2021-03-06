(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

(* Preamble *)

Require Import GHC.Base.
Require Import GHC.Num.

(* Converted data type declarations: *)
Inductive Down a : Type := Mk_Down : a -> Down a.
Arguments Mk_Down {_}.

Instance instance_Down_Eq {a} `(Eq_ a) : Eq_ (Down a) := {
  op_zeze__ := (fun x y =>
                match x, y with
                | Mk_Down x0, Mk_Down y0 => x0 == y0
                end);
  op_zsze__ := (fun x y =>
                match x, y with
                | Mk_Down x0, Mk_Down y0 => x0 /= y0
                end)
}.

Definition compare_Down `{Ord a} (xs : Down a) (ys : Down a) : comparison :=
  match xs, ys with
  | Mk_Down x , Mk_Down y => compare y x
  end.

Instance instance_forall___GHC_Base_Ord_a___GHC_Base_Ord__Down_a_
   `{GHC.Base.Ord a}: !GHC.Base.Ord (Down a) := ord_default compare_Down.

(*
 ( Eq
   , Show -- ^ @since 4.7.0.0
   , Read -- ^ @since 4.7.0.0
   , Num -- ^ @since 4.11.0.0
   , Monoid -- ^ @since 4.11.0.0
*)

(* Converted imports: *)

Require GHC.Base.

(* Converted declarations: *)

(* Skipping instance instance_forall___GHC_Base_Ord_a___GHC_Base_Ord__Down_a_ *)

(* Skipping instance
   instance_forall___GHC_Read_Read_a___GHC_Read_Read__Down_a_ *)

(* Skipping instance
   instance_forall___GHC_Show_Show_a___GHC_Show_Show__Down_a_ *)

(* Translating `instance forall {a}, forall `{GHC.Base.Eq_ a}, GHC.Base.Eq_
   (Down a)' failed: type applications unsupported *)

Definition comparing {a} {b} `{(GHC.Base.Ord a)}
    : (b -> a) -> b -> b -> comparison :=
  fun arg_0__ arg_1__ arg_2__ =>
    match arg_0__ , arg_1__ , arg_2__ with
      | p , x , y => GHC.Base.compare (p x) (p y)
    end.

(* Unbound variables:
     GHC.Base.Ord GHC.Base.compare comparison
*)
