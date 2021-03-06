(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

(* Preamble *)


(* Converted imports: *)

Require Coq.Program.Basics.
Require Data.Monoid.
Require Data.Proxy.
Require GHC.Base.
Require GHC.List.
Require GHC.Num.

(* Converted declarations: *)

(* Skipping instance instance_Foldable_option *)

Local Definition instance_Foldable_list_elem : forall {a},
                                                 forall `{GHC.Base.Eq_ a}, a -> list a -> bool :=
  fun {a} `{GHC.Base.Eq_ a} => GHC.List.elem.

Local Definition instance_Foldable_list_foldl : forall {b} {a},
                                                  (b -> a -> b) -> b -> list a -> b :=
  fun {b} {a} => GHC.Base.foldl.

Local Definition instance_Foldable_list_foldr' : forall {a} {b},
                                                   (a -> b -> b) -> b -> list a -> b :=
  fun {a} {b} =>
    fun arg_9__ arg_10__ arg_11__ =>
      match arg_9__ , arg_10__ , arg_11__ with
        | f , z0 , xs => let f' :=
                           fun arg_12__ arg_13__ arg_14__ =>
                             match arg_12__ , arg_13__ , arg_14__ with
                               | k , x , z => GHC.Base.op_zdzn__ k (f x z)
                             end in
                         instance_Foldable_list_foldl f' GHC.Base.id xs z0
      end.

Local Definition instance_Foldable_list_foldl' : forall {b} {a},
                                                   (b -> a -> b) -> b -> list a -> b :=
  fun {b} {a} => GHC.Base.foldl'.

Local Definition instance_Foldable_list_foldr : forall {a} {b},
                                                  (a -> b -> b) -> b -> list a -> b :=
  fun {a} {b} => GHC.Base.foldr.

Local Definition instance_Foldable_list_foldMap : forall {m} {a},
                                                    forall `{GHC.Base.Monoid m}, (a -> m) -> list a -> m :=
  fun {m} {a} `{GHC.Base.Monoid m} =>
    fun arg_1__ =>
      match arg_1__ with
        | f => instance_Foldable_list_foldr (Coq.Program.Basics.compose GHC.Base.mappend
                                                                        f) GHC.Base.mempty
      end.

Local Definition instance_Foldable_list_fold : forall {m},
                                                 forall `{GHC.Base.Monoid m}, list m -> m :=
  fun {m} `{GHC.Base.Monoid m} => instance_Foldable_list_foldMap GHC.Base.id.

Local Definition instance_Foldable_list_length : forall {a},
                                                   list a -> GHC.Num.Int :=
  fun {a} => GHC.List.length.

Local Definition instance_Foldable_list_null : forall {a}, list a -> bool :=
  fun {a} => GHC.List.null.

Local Definition instance_Foldable_list_product : forall {a},
                                                    forall `{GHC.Num.Num a}, list a -> a :=
  fun {a} `{GHC.Num.Num a} => GHC.List.product.

Local Definition instance_Foldable_list_sum : forall {a},
                                                forall `{GHC.Num.Num a}, list a -> a :=
  fun {a} `{GHC.Num.Num a} => GHC.List.sum.

Local Definition instance_Foldable_list_toList : forall {a}, list a -> list a :=
  fun {a} => GHC.Base.id.

(* Skipping instance instance_Foldable__sum_a_ *)

(* Skipping instance instance_Foldable__GHC_Tuple_pair_type_a_ *)

(* Skipping instance instance_Foldable__GHC_Arr_Array_i_ *)

Local Definition instance_Foldable_Data_Proxy_Proxy_elem : forall {a},
                                                             forall `{GHC.Base.Eq_ a},
                                                               a -> Data.Proxy.Proxy a -> bool :=
  fun {a} `{GHC.Base.Eq_ a} => fun arg_408__ arg_409__ => false.

Local Definition instance_Foldable_Data_Proxy_Proxy_fold : forall {m},
                                                             forall `{GHC.Base.Monoid m}, Data.Proxy.Proxy m -> m :=
  fun {m} `{GHC.Base.Monoid m} => fun arg_387__ => GHC.Base.mempty.

Local Definition instance_Foldable_Data_Proxy_Proxy_foldMap : forall {m} {a},
                                                                forall `{GHC.Base.Monoid m},
                                                                  (a -> m) -> Data.Proxy.Proxy a -> m :=
  fun {m} {a} `{GHC.Base.Monoid m} => fun arg_385__ arg_386__ => GHC.Base.mempty.

Local Definition instance_Foldable_Data_Proxy_Proxy_foldl : forall {b} {a},
                                                              (b -> a -> b) -> b -> Data.Proxy.Proxy a -> b :=
  fun {b} {a} =>
    fun arg_392__ arg_393__ arg_394__ =>
      match arg_392__ , arg_393__ , arg_394__ with
        | _ , z , _ => z
      end.

Local Definition instance_Foldable_Data_Proxy_Proxy_foldr' : forall {a} {b},
                                                               (a -> b -> b) -> b -> Data.Proxy.Proxy a -> b :=
  fun {a} {b} =>
    fun arg_9__ arg_10__ arg_11__ =>
      match arg_9__ , arg_10__ , arg_11__ with
        | f , z0 , xs => let f' :=
                           fun arg_12__ arg_13__ arg_14__ =>
                             match arg_12__ , arg_13__ , arg_14__ with
                               | k , x , z => GHC.Base.op_zdzn__ k (f x z)
                             end in
                         instance_Foldable_Data_Proxy_Proxy_foldl f' GHC.Base.id xs z0
      end.

Local Definition instance_Foldable_Data_Proxy_Proxy_foldr : forall {a} {b},
                                                              (a -> b -> b) -> b -> Data.Proxy.Proxy a -> b :=
  fun {a} {b} =>
    fun arg_388__ arg_389__ arg_390__ =>
      match arg_388__ , arg_389__ , arg_390__ with
        | _ , z , _ => z
      end.

Local Definition instance_Foldable_Data_Proxy_Proxy_toList : forall {a},
                                                               Data.Proxy.Proxy a -> list a :=
  fun {a} =>
    fun arg_54__ =>
      match arg_54__ with
        | t => GHC.Base.build (fun arg_55__ arg_56__ =>
                                match arg_55__ , arg_56__ with
                                  | c , n => instance_Foldable_Data_Proxy_Proxy_foldr c n t
                                end)
      end.

Local Definition instance_Foldable_Data_Proxy_Proxy_foldl' : forall {b} {a},
                                                               (b -> a -> b) -> b -> Data.Proxy.Proxy a -> b :=
  fun {b} {a} =>
    fun arg_24__ arg_25__ arg_26__ =>
      match arg_24__ , arg_25__ , arg_26__ with
        | f , z0 , xs => let f' :=
                           fun arg_27__ arg_28__ arg_29__ =>
                             match arg_27__ , arg_28__ , arg_29__ with
                               | x , k , z => GHC.Base.op_zdzn__ k (f z x)
                             end in
                         instance_Foldable_Data_Proxy_Proxy_foldr f' GHC.Base.id xs z0
      end.

Local Definition instance_Foldable_Data_Proxy_Proxy_length : forall {a},
                                                               Data.Proxy.Proxy a -> GHC.Num.Int :=
  fun {a} => fun arg_404__ => GHC.Num.fromInteger 0.

Local Definition instance_Foldable_Data_Proxy_Proxy_null : forall {a},
                                                             Data.Proxy.Proxy a -> bool :=
  fun {a} => fun arg_407__ => true.

Local Definition instance_Foldable_Data_Proxy_Proxy_product : forall {a},
                                                                forall `{GHC.Num.Num a}, Data.Proxy.Proxy a -> a :=
  fun {a} `{GHC.Num.Num a} => fun arg_413__ => GHC.Num.fromInteger 1.

Local Definition instance_Foldable_Data_Proxy_Proxy_sum : forall {a},
                                                            forall `{GHC.Num.Num a}, Data.Proxy.Proxy a -> a :=
  fun {a} `{GHC.Num.Num a} => fun arg_410__ => GHC.Num.fromInteger 0.

(* Skipping instance instance_Foldable_Data_Monoid_Dual *)

(* Skipping instance instance_Foldable_Data_Monoid_Sum *)

(* Skipping instance instance_Foldable_Data_Monoid_Product *)

(* Skipping instance instance_Foldable_Data_Monoid_First *)

(* Skipping instance instance_Foldable_Data_Monoid_Last *)

(* Skipping instance
   instance_forall___GHC_Base_Ord_a___GHC_Base_Monoid__Max_a_ *)

(* Skipping instance
   instance_forall___GHC_Base_Ord_a___GHC_Base_Monoid__Min_a_ *)

(* Skipping instance instance_Foldable_GHC_Generics_U1 *)

(* Skipping instance instance_Foldable_GHC_Generics_V1 *)

(* Skipping instance instance_Foldable_GHC_Generics_Par1 *)

(* Skipping instance
   instance_forall___Foldable_f___Foldable__GHC_Generics_Rec1_f_ *)

(* Skipping instance instance_Foldable__GHC_Generics_K1_i_c_ *)

(* Skipping instance
   instance_forall___Foldable_f___Foldable__GHC_Generics_M1_i_c_f_ *)

(* Skipping instance
   instance_forall___Foldable_f____Foldable_g___Foldable__GHC_Generics_____f_g_ *)

(* Skipping instance
   instance_forall___Foldable_f____Foldable_g___Foldable__GHC_Generics_____f_g_ *)

(* Skipping instance
   instance_forall___Foldable_f____Foldable_g___Foldable__GHC_Generics_____f_g_ *)

(* Skipping instance instance_Foldable__GHC_Generics_URec__GHC_Ptr_Ptr_unit__ *)

(* Skipping instance instance_Foldable__GHC_Generics_URec_GHC_Char_Char_ *)

(* Skipping instance instance_Foldable__GHC_Generics_URec_GHC_Types_Double_ *)

(* Skipping instance instance_Foldable__GHC_Generics_URec_GHC_Types_Float_ *)

(* Skipping instance instance_Foldable__GHC_Generics_URec_GHC_Num_Int_ *)

(* Skipping instance instance_Foldable__GHC_Generics_URec_GHC_Num_Word_ *)

Definition hash_compose {a} {b} {c} :=
  (@Coq.Program.Basics.compose a b c).

Class Foldable t := {
  elem : forall {a}, forall `{GHC.Base.Eq_ a}, a -> t a -> bool ;
  fold : forall {m}, forall `{GHC.Base.Monoid m}, t m -> m ;
  foldMap : forall {m} {a}, forall `{GHC.Base.Monoid m}, (a -> m) -> t a -> m ;
  foldl : forall {b} {a}, (b -> a -> b) -> b -> t a -> b ;
  foldl' : forall {b} {a}, (b -> a -> b) -> b -> t a -> b ;
  foldr : forall {a} {b}, (a -> b -> b) -> b -> t a -> b ;
  foldr' : forall {a} {b}, (a -> b -> b) -> b -> t a -> b ;
  length : forall {a}, t a -> GHC.Num.Int ;
  null : forall {a}, t a -> bool ;
  product : forall {a}, forall `{GHC.Num.Num a}, t a -> a ;
  sum : forall {a}, forall `{GHC.Num.Num a}, t a -> a ;
  toList : forall {a}, t a -> list a }.

Definition traverse_ {t} {f} {a} {b} `{Foldable t} `{GHC.Base.Applicative f}
    : (a -> f b) -> t a -> f unit :=
  fun arg_125__ =>
    match arg_125__ with
      | f => foldr (Coq.Program.Basics.compose GHC.Base.op_ztzg__ f) (GHC.Base.pure
                                                                     tt)
    end.

Definition sequence_ {t} {m} {a} `{Foldable t} `{GHC.Base.Monad m} : t (m
                                                                       a) -> m unit :=
  foldr GHC.Base.op_zgzg__ (GHC.Base.return_ tt).

Definition sequenceA_ {t} {f} {a} `{Foldable t} `{GHC.Base.Applicative f} : t (f
                                                                              a) -> f unit :=
  foldr GHC.Base.op_ztzg__ (GHC.Base.pure tt).

Definition notElem {t} {a} `{Foldable t} `{GHC.Base.Eq_ a} : a -> t a -> bool :=
  fun arg_84__ =>
    match arg_84__ with
      | x => Coq.Program.Basics.compose negb (elem x)
    end.

Definition mapM_ {t} {m} {a} {b} `{Foldable t} `{GHC.Base.Monad m} : (a -> m
                                                                     b) -> t a -> m unit :=
  fun arg_121__ =>
    match arg_121__ with
      | f => foldr (Coq.Program.Basics.compose GHC.Base.op_zgzg__ f) (GHC.Base.return_
                                                                     tt)
    end.

Definition or {t} `{Foldable t} : t bool -> bool :=
  hash_compose Data.Monoid.getAny (foldMap Data.Monoid.Mk_Any).

Definition for__ {t} {f} {a} {b} `{Foldable t} `{GHC.Base.Applicative f} : t
                                                                           a -> (a -> f b) -> f unit :=
  GHC.Base.flip traverse_.

Definition forM_ {t} {m} {a} {b} `{Foldable t} `{GHC.Base.Monad m} : t
                                                                     a -> (a -> m b) -> m unit :=
  GHC.Base.flip mapM_.

Definition foldrM {t} {m} {a} {b} `{Foldable t} `{GHC.Base.Monad m}
    : (a -> b -> m b) -> b -> t a -> m b :=
  fun arg_139__ arg_140__ arg_141__ =>
    match arg_139__ , arg_140__ , arg_141__ with
      | f , z0 , xs => let f' :=
                         fun arg_142__ arg_143__ arg_144__ =>
                           match arg_142__ , arg_143__ , arg_144__ with
                             | k , x , z => GHC.Base.op_zgzgze__ (f x z) k
                           end in
                       foldl f' GHC.Base.return_ xs z0
    end.

Definition foldlM {t} {m} {b} {a} `{Foldable t} `{GHC.Base.Monad m}
    : (b -> a -> m b) -> b -> t a -> m b :=
  fun arg_129__ arg_130__ arg_131__ =>
    match arg_129__ , arg_130__ , arg_131__ with
      | f , z0 , xs => let f' :=
                         fun arg_132__ arg_133__ arg_134__ =>
                           match arg_132__ , arg_133__ , arg_134__ with
                             | x , k , z => GHC.Base.op_zgzgze__ (f z x) k
                           end in
                       foldr f' GHC.Base.return_ xs z0
    end.

Definition find {t} {a} `{Foldable t} : (a -> bool) -> t a -> option a :=
  fun arg_78__ =>
    match arg_78__ with
      | p => Coq.Program.Basics.compose Data.Monoid.getFirst (foldMap (fun arg_79__ =>
                                                                        match arg_79__ with
                                                                          | x => Data.Monoid.Mk_First (if p x : bool
                                                                                                      then Some x
                                                                                                      else None)
                                                                        end))
    end.

Definition asum {t} {f} {a} `{Foldable t} `{GHC.Base.Alternative f} : t (f
                                                                        a) -> f a :=
  foldr GHC.Base.op_zlzbzg__ GHC.Base.empty.

Definition msum {t} {m} {a} `{Foldable t} `{GHC.Base.MonadPlus m} : t (m a) -> m
                                                                    a :=
  asum.

Definition any {t} {a} `{Foldable t} : (a -> bool) -> t a -> bool :=
  fun arg_90__ =>
    match arg_90__ with
      | p => hash_compose Data.Monoid.getAny (foldMap (hash_compose Data.Monoid.Mk_Any
                                                                    p))
    end.

Definition and {t} `{Foldable t} : t bool -> bool :=
  hash_compose Data.Monoid.getAll (foldMap Data.Monoid.Mk_All).

Definition all {t} {a} `{Foldable t} : (a -> bool) -> t a -> bool :=
  fun arg_87__ =>
    match arg_87__ with
      | p => hash_compose Data.Monoid.getAll (foldMap (hash_compose Data.Monoid.Mk_All
                                                                    p))
    end.

Instance instance_Foldable_Data_Proxy_Proxy : Foldable Data.Proxy.Proxy := {
  elem := fun {a} `{GHC.Base.Eq_ a} => instance_Foldable_Data_Proxy_Proxy_elem ;
  fold := fun {m} `{GHC.Base.Monoid m} =>
    instance_Foldable_Data_Proxy_Proxy_fold ;
  foldMap := fun {m} {a} `{GHC.Base.Monoid m} =>
    instance_Foldable_Data_Proxy_Proxy_foldMap ;
  foldl := fun {b} {a} => instance_Foldable_Data_Proxy_Proxy_foldl ;
  foldl' := fun {b} {a} => instance_Foldable_Data_Proxy_Proxy_foldl' ;
  foldr := fun {a} {b} => instance_Foldable_Data_Proxy_Proxy_foldr ;
  foldr' := fun {a} {b} => instance_Foldable_Data_Proxy_Proxy_foldr' ;
  length := fun {a} => instance_Foldable_Data_Proxy_Proxy_length ;
  null := fun {a} => instance_Foldable_Data_Proxy_Proxy_null ;
  product := fun {a} `{GHC.Num.Num a} =>
    instance_Foldable_Data_Proxy_Proxy_product ;
  sum := fun {a} `{GHC.Num.Num a} => instance_Foldable_Data_Proxy_Proxy_sum ;
  toList := fun {a} => instance_Foldable_Data_Proxy_Proxy_toList }.

Instance instance_Foldable_list : Foldable list := {
  elem := fun {a} `{GHC.Base.Eq_ a} => instance_Foldable_list_elem ;
  fold := fun {m} `{GHC.Base.Monoid m} => instance_Foldable_list_fold ;
  foldMap := fun {m} {a} `{GHC.Base.Monoid m} => instance_Foldable_list_foldMap ;
  foldl := fun {b} {a} => instance_Foldable_list_foldl ;
  foldl' := fun {b} {a} => instance_Foldable_list_foldl' ;
  foldr := fun {a} {b} => instance_Foldable_list_foldr ;
  foldr' := fun {a} {b} => instance_Foldable_list_foldr' ;
  length := fun {a} => instance_Foldable_list_length ;
  null := fun {a} => instance_Foldable_list_null ;
  product := fun {a} `{GHC.Num.Num a} => instance_Foldable_list_product ;
  sum := fun {a} `{GHC.Num.Num a} => instance_Foldable_list_sum ;
  toList := fun {a} => instance_Foldable_list_toList }.

Definition concatMap {t} {a} {b} `{Foldable t} : (a -> list b) -> t a -> list
                                                 b :=
  fun arg_95__ arg_96__ =>
    match arg_95__ , arg_96__ with
      | f , xs => GHC.Base.build (fun arg_97__ arg_98__ =>
                                   match arg_97__ , arg_98__ with
                                     | c , n => foldr (fun arg_99__ arg_100__ =>
                                                        match arg_99__ , arg_100__ with
                                                          | x , b => foldr c b (f x)
                                                        end) n xs
                                   end)
    end.

Definition concat {t} {a} `{Foldable t} : t (list a) -> list a :=
  fun arg_107__ =>
    match arg_107__ with
      | xs => GHC.Base.build (fun arg_108__ arg_109__ =>
                               match arg_108__ , arg_109__ with
                                 | c , n => foldr (fun arg_110__ arg_111__ =>
                                                    match arg_110__ , arg_111__ with
                                                      | x , y => foldr c y x
                                                    end) n xs
                               end)
    end.

Inductive Max a : Type := Mk_Max : option a -> Max a.

Arguments Mk_Max {_} _.

Definition getMax {a} (arg_75__ : Max a) :=
  match arg_75__ with
    | Mk_Max getMax => getMax
  end.

Inductive Min a : Type := Mk_Min : option a -> Min a.

Arguments Mk_Min {_} _.

Definition getMin {a} (arg_74__ : Min a) :=
  match arg_74__ with
    | Mk_Min getMin => getMin
  end.

(* Unbound variables:
     Coq.Program.Basics.compose Data.Monoid.Mk_All Data.Monoid.Mk_Any
     Data.Monoid.Mk_First Data.Monoid.getAll Data.Monoid.getAny Data.Monoid.getFirst
     Data.Proxy.Proxy GHC.Base.Alternative GHC.Base.Applicative GHC.Base.Eq_
     GHC.Base.Monad GHC.Base.MonadPlus GHC.Base.Monoid GHC.Base.build GHC.Base.empty
     GHC.Base.flip GHC.Base.foldl GHC.Base.foldl' GHC.Base.foldr GHC.Base.id
     GHC.Base.mappend GHC.Base.mempty GHC.Base.op_zdzn__ GHC.Base.op_zgzg__
     GHC.Base.op_zgzgze__ GHC.Base.op_zlzbzg__ GHC.Base.op_ztzg__ GHC.Base.pure
     GHC.Base.return_ GHC.List.elem GHC.List.length GHC.List.null GHC.List.product
     GHC.List.sum GHC.Num.Int GHC.Num.Num None Some bool false list negb option true
     tt unit
*)
