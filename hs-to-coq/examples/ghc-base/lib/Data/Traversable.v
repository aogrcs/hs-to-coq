(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

(* Preamble *)

Require Data.FoldableInst.

(* Converted imports: *)

Require Coq.Program.Basics.
Require Data.Foldable.
Require Data.Functor.
Require Data.Proxy.
Require GHC.Base.

(* Converted declarations: *)

Local Definition instance_Traversable_option_traverse : forall {f} {a} {b},
                                                          forall `{GHC.Base.Applicative f},
                                                            (a -> f b) -> option a -> f (option b) :=
  fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    fun arg_218__ arg_219__ =>
      match arg_218__ , arg_219__ with
        | _ , None => GHC.Base.pure None
        | f , Some x => Data.Functor.op_zlzdzg__ Some (f x)
      end.

Local Definition instance_Traversable_option_sequenceA : forall {f} {a},
                                                           forall `{GHC.Base.Applicative f},
                                                             option (f a) -> f (option a) :=
  fun {f} {a} `{GHC.Base.Applicative f} =>
    instance_Traversable_option_traverse GHC.Base.id.

Local Definition instance_Traversable_option_sequence : forall {m} {a},
                                                          forall `{GHC.Base.Monad m}, option (m a) -> m (option a) :=
  fun {m} {a} `{GHC.Base.Monad m} => instance_Traversable_option_sequenceA.

Local Definition instance_Traversable_option_mapM : forall {m} {a} {b},
                                                      forall `{GHC.Base.Monad m},
                                                        (a -> m b) -> option a -> m (option b) :=
  fun {m} {a} {b} `{GHC.Base.Monad m} => instance_Traversable_option_traverse.

Local Definition instance_Traversable_list_traverse : forall {f} {a} {b},
                                                        forall `{GHC.Base.Applicative f},
                                                          (a -> f b) -> list a -> f (list b) :=
  fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    fun arg_211__ =>
      match arg_211__ with
        | f => let cons_f :=
                 fun arg_212__ arg_213__ =>
                   match arg_212__ , arg_213__ with
                     | x , ys => GHC.Base.op_zlztzg__ (Data.Functor.op_zlzdzg__ cons (f x)) ys
                   end in
               GHC.Base.foldr cons_f (GHC.Base.pure nil)
      end.

Local Definition instance_Traversable_list_sequenceA : forall {f} {a},
                                                         forall `{GHC.Base.Applicative f}, list (f a) -> f (list a) :=
  fun {f} {a} `{GHC.Base.Applicative f} =>
    instance_Traversable_list_traverse GHC.Base.id.

Local Definition instance_Traversable_list_sequence : forall {m} {a},
                                                        forall `{GHC.Base.Monad m}, list (m a) -> m (list a) :=
  fun {m} {a} `{GHC.Base.Monad m} => instance_Traversable_list_sequenceA.

Local Definition instance_Traversable_list_mapM : forall {m} {a} {b},
                                                    forall `{GHC.Base.Monad m}, (a -> m b) -> list a -> m (list b) :=
  fun {m} {a} {b} `{GHC.Base.Monad m} => instance_Traversable_list_traverse.

(* Skipping instance instance_Traversable__sum_a_ *)

(* Skipping instance instance_Traversable__GHC_Tuple_pair_type_a_ *)

(* Skipping instance
   instance_forall___GHC_Arr_Ix_i___Traversable__GHC_Arr_Array_i_ *)

Local Definition instance_Traversable_Data_Proxy_Proxy_mapM : forall {m}
                                                                     {a}
                                                                     {b},
                                                                forall `{GHC.Base.Monad m},
                                                                  (a -> m b) -> Data.Proxy.Proxy a -> m
                                                                  (Data.Proxy.Proxy b) :=
  fun {m} {a} {b} `{GHC.Base.Monad m} =>
    fun arg_191__ arg_192__ => GHC.Base.pure Data.Proxy.Mk_Proxy.

Local Definition instance_Traversable_Data_Proxy_Proxy_sequence : forall {m}
                                                                         {a},
                                                                    forall `{GHC.Base.Monad m},
                                                                      Data.Proxy.Proxy (m a) -> m (Data.Proxy.Proxy
                                                                                                  a) :=
  fun {m} {a} `{GHC.Base.Monad m} =>
    fun arg_195__ => GHC.Base.pure Data.Proxy.Mk_Proxy.

Local Definition instance_Traversable_Data_Proxy_Proxy_sequenceA : forall {f}
                                                                          {a},
                                                                     forall `{GHC.Base.Applicative f},
                                                                       Data.Proxy.Proxy (f a) -> f (Data.Proxy.Proxy
                                                                                                   a) :=
  fun {f} {a} `{GHC.Base.Applicative f} =>
    fun arg_188__ => GHC.Base.pure Data.Proxy.Mk_Proxy.

Local Definition instance_Traversable_Data_Proxy_Proxy_traverse : forall {f}
                                                                         {a}
                                                                         {b},
                                                                    forall `{GHC.Base.Applicative f},
                                                                      (a -> f b) -> Data.Proxy.Proxy a -> f
                                                                      (Data.Proxy.Proxy b) :=
  fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    fun arg_184__ arg_185__ => GHC.Base.pure Data.Proxy.Mk_Proxy.

(* Skipping instance instance_Traversable__Data_Functor_Const_Const_m_ *)

(* Skipping instance instance_Traversable_Data_Monoid_Dual *)

(* Skipping instance instance_Traversable_Data_Monoid_Sum *)

(* Skipping instance instance_Traversable_Data_Monoid_Product *)

(* Skipping instance instance_Traversable_Data_Monoid_First *)

(* Skipping instance instance_Traversable_Data_Monoid_Last *)

(* Skipping instance instance_Traversable_Control_Applicative_ZipList *)

(* Skipping instance instance_Traversable_GHC_Generics_U1 *)

(* Skipping instance instance_GHC_Base_Functor__StateL_s_ *)

(* Skipping instance instance_GHC_Base_Applicative__StateL_s_ *)

(* Skipping instance instance_GHC_Base_Functor__StateR_s_ *)

(* Skipping instance instance_GHC_Base_Applicative__StateR_s_ *)

(* Skipping instance instance_Traversable_GHC_Generics_V1 *)

(* Skipping instance instance_Traversable_GHC_Generics_Par1 *)

(* Skipping instance
   instance_forall___Traversable_f___Traversable__GHC_Generics_Rec1_f_ *)

(* Skipping instance instance_Traversable__GHC_Generics_K1_i_c_ *)

(* Skipping instance
   instance_forall___Traversable_f___Traversable__GHC_Generics_M1_i_c_f_ *)

(* Skipping instance
   instance_forall___Traversable_f____Traversable_g___Traversable__GHC_Generics_____f_g_ *)

(* Skipping instance
   instance_forall___Traversable_f____Traversable_g___Traversable__GHC_Generics_____f_g_ *)

(* Skipping instance
   instance_forall___Traversable_f____Traversable_g___Traversable__GHC_Generics_____f_g_ *)

(* Skipping instance
   instance_Traversable__GHC_Generics_URec__GHC_Ptr_Ptr_unit__ *)

(* Skipping instance instance_Traversable__GHC_Generics_URec_GHC_Char_Char_ *)

(* Skipping instance
   instance_Traversable__GHC_Generics_URec_GHC_Types_Double_ *)

(* Skipping instance instance_Traversable__GHC_Generics_URec_GHC_Types_Float_ *)

(* Skipping instance instance_Traversable__GHC_Generics_URec_GHC_Num_Int_ *)

(* Skipping instance instance_Traversable__GHC_Generics_URec_GHC_Num_Word_ *)

Inductive Id a : Type := Mk_Id : a -> Id a.

Arguments Mk_Id {_} _.

Definition getId {a} (arg_6__ : Id a) :=
  match arg_6__ with
    | Mk_Id getId => getId
  end.

Local Definition instance_GHC_Base_Applicative_Id_pure : forall {a},
                                                           a -> Id a :=
  fun {a} => Mk_Id.

Local Definition instance_GHC_Base_Functor_Id_fmap : forall {a} {b},
                                                       (a -> b) -> Id a -> Id b :=
  fun {a} {b} =>
    fun arg_92__ arg_93__ =>
      match arg_92__ , arg_93__ with
        | f , Mk_Id x => Mk_Id (f x)
      end.

Local Definition instance_GHC_Base_Functor_Id_op_zlzd__ : forall {a} {b},
                                                            b -> Id a -> Id b :=
  fun {a} {b} => fun x => instance_GHC_Base_Functor_Id_fmap (GHC.Base.const x).

Instance instance_GHC_Base_Functor_Id : GHC.Base.Functor Id := {
  fmap := fun {a} {b} => instance_GHC_Base_Functor_Id_fmap ;
  op_zlzd__ := fun {a} {b} => instance_GHC_Base_Functor_Id_op_zlzd__ }.

Local Definition instance_GHC_Base_Applicative_Id_op_zlztzg__ : forall {a} {b},
                                                                  Id (a -> b) -> Id a -> Id b :=
  fun {a} {b} =>
    fun arg_88__ arg_89__ =>
      match arg_88__ , arg_89__ with
        | Mk_Id f , Mk_Id x => Mk_Id (f x)
      end.

Local Definition instance_GHC_Base_Applicative_Id_op_ztzg__ : forall {a} {b},
                                                                Id a -> Id b -> Id b :=
  fun {a} {b} =>
    fun x y =>
      instance_GHC_Base_Applicative_Id_op_zlztzg__ (GHC.Base.fmap (GHC.Base.const
                                                                  GHC.Base.id) x) y.

Instance instance_GHC_Base_Applicative_Id : GHC.Base.Applicative Id := {
  op_zlztzg__ := fun {a} {b} => instance_GHC_Base_Applicative_Id_op_zlztzg__ ;
  op_ztzg__ := fun {a} {b} => instance_GHC_Base_Applicative_Id_op_ztzg__ ;
  pure := fun {a} => instance_GHC_Base_Applicative_Id_pure }.

Inductive StateL s a : Type := Mk_StateL : (s -> s * a) -> StateL s a.

Arguments Mk_StateL {_} {_} _.

Definition runStateL {s} {a} (arg_5__ : StateL s a) :=
  match arg_5__ with
    | Mk_StateL runStateL => runStateL
  end.

Inductive StateR s a : Type := Mk_StateR : (s -> s * a) -> StateR s a.

Arguments Mk_StateR {_} {_} _.

Definition runStateR {s} {a} (arg_4__ : StateR s a) :=
  match arg_4__ with
    | Mk_StateR runStateR => runStateR
  end.

Class Traversable t `{GHC.Base.Functor t} `{Data.Foldable.Foldable t} := {
  mapM : forall {m} {a} {b},
    forall `{GHC.Base.Monad m}, (a -> m b) -> t a -> m (t b) ;
  sequence : forall {m} {a}, forall `{GHC.Base.Monad m}, t (m a) -> m (t a) ;
  sequenceA : forall {f} {a},
    forall `{GHC.Base.Applicative f}, t (f a) -> f (t a) ;
  traverse : forall {f} {a} {b},
    forall `{GHC.Base.Applicative f}, (a -> f b) -> t a -> f (t b) }.

Definition for_ {t} {f} {a} {b} `{Traversable t} `{GHC.Base.Applicative f} : t
                                                                             a -> (a -> f b) -> f (t b) :=
  GHC.Base.flip traverse.

Definition forM {t} {m} {a} {b} `{Traversable t} `{GHC.Base.Monad m} : t
                                                                       a -> (a -> m b) -> m (t b) :=
  GHC.Base.flip mapM.

Definition fmapDefault {t} {a} {b} `{Traversable t} : (a -> b) -> t a -> t b :=
  fun arg_7__ =>
    match arg_7__ with
      | f => Coq.Program.Basics.compose getId (traverse (Coq.Program.Basics.compose
                                                        Mk_Id f))
    end.

Instance instance_Traversable_Data_Proxy_Proxy : Traversable Data.Proxy.Proxy :=
  {
  mapM := fun {m} {a} {b} `{GHC.Base.Monad m} =>
    instance_Traversable_Data_Proxy_Proxy_mapM ;
  sequence := fun {m} {a} `{GHC.Base.Monad m} =>
    instance_Traversable_Data_Proxy_Proxy_sequence ;
  sequenceA := fun {f} {a} `{GHC.Base.Applicative f} =>
    instance_Traversable_Data_Proxy_Proxy_sequenceA ;
  traverse := fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    instance_Traversable_Data_Proxy_Proxy_traverse }.

Instance instance_Traversable_list : Traversable list := {
  mapM := fun {m} {a} {b} `{GHC.Base.Monad m} => instance_Traversable_list_mapM ;
  sequence := fun {m} {a} `{GHC.Base.Monad m} =>
    instance_Traversable_list_sequence ;
  sequenceA := fun {f} {a} `{GHC.Base.Applicative f} =>
    instance_Traversable_list_sequenceA ;
  traverse := fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    instance_Traversable_list_traverse }.

Instance instance_Traversable_option : Traversable option := {
  mapM := fun {m} {a} {b} `{GHC.Base.Monad m} =>
    instance_Traversable_option_mapM ;
  sequence := fun {m} {a} `{GHC.Base.Monad m} =>
    instance_Traversable_option_sequence ;
  sequenceA := fun {f} {a} `{GHC.Base.Applicative f} =>
    instance_Traversable_option_sequenceA ;
  traverse := fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    instance_Traversable_option_traverse }.

(* Unbound variables:
     * Coq.Program.Basics.compose Data.Foldable.Foldable Data.Functor.op_zlzdzg__
     Data.Proxy.Mk_Proxy Data.Proxy.Proxy GHC.Base.Applicative GHC.Base.Functor
     GHC.Base.Monad GHC.Base.const GHC.Base.flip GHC.Base.fmap GHC.Base.foldr
     GHC.Base.id GHC.Base.op_zlztzg__ GHC.Base.pure Some cons list nil option
*)
