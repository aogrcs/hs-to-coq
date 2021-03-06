(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

(* Preamble *)


(* Converted imports: *)

Require Coq.Lists.List.

(* Converted declarations: *)

Definition catMaybes {a} : list (option a) -> list a :=
  fun arg_17__ =>
    match arg_17__ with
      | ls => let cont_18__ arg_19__ :=
                match arg_19__ with
                  | Some x => cons x nil
                  | _ => nil
                end in
              Coq.Lists.List.flat_map cont_18__ ls
    end.

Definition fromMaybe {a} : a -> option a -> a :=
  fun arg_28__ arg_29__ =>
    match arg_28__ , arg_29__ with
      | d , x => match x with
                   | None => d
                   | Some v => v
                 end
    end.

Definition isJust {a} : option a -> bool :=
  fun arg_35__ => match arg_35__ with | None => false | _ => true end.

Definition isNothing {a} : option a -> bool :=
  fun arg_33__ => match arg_33__ with | None => true | _ => false end.

Definition listToMaybe {a} : list a -> option a :=
  fun arg_22__ => match arg_22__ with | nil => None | cons a _ => Some a end.

Definition mapMaybe {a} {b} : (a -> option b) -> list a -> list b :=
  fix mapMaybe arg_9__ arg_10__
        := match arg_9__ , arg_10__ with
             | _ , nil => nil
             | f , cons x xs => let rs := mapMaybe f xs in
                                let scrut_12__ := f x in
                                match scrut_12__ with
                                  | None => rs
                                  | Some r => cons r rs
                                end
           end.

Definition mapMaybeFB {b} {r} {a} : (b -> r -> r) -> (a -> option
                                    b) -> a -> r -> r :=
  fun arg_0__ arg_1__ arg_2__ arg_3__ =>
    match arg_0__ , arg_1__ , arg_2__ , arg_3__ with
      | cons_ , f , x , next => let scrut_4__ := f x in
                                match scrut_4__ with
                                  | None => next
                                  | Some r => cons_ r next
                                end
    end.

Definition maybe {b} {a} : b -> (a -> b) -> option a -> b :=
  fun arg_37__ arg_38__ arg_39__ =>
    match arg_37__ , arg_38__ , arg_39__ with
      | n , _ , None => n
      | _ , f , Some x => f x
    end.

Definition maybeToList {a} : option a -> list a :=
  fun arg_25__ => match arg_25__ with | None => nil | Some x => cons x nil end.

(* Unbound variables:
     Coq.Lists.List.flat_map None Some bool cons false list nil option true
*)
