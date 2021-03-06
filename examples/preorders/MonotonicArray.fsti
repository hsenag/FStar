(*
   Copyright 2008-2018 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
module MonotonicArray

open FStar.Preorder
open FStar.Heap
open FStar.ST

module Set = FStar.Set

open FStar.Seq

open ArrayUtils


(*
 * an array is a mref and an offset into the array (for taking interior pointers)
 * the view of an array is from offset to m
 *)

val t (a:Type0) (n:nat) : Type0

val mutable_pred (#a:Type0) (#n:nat) (x:t a n) : (p:heap_predicate{stable p})

val freezable_pred (#a:Type0) (#n:nat) (x:t a n) : (p:heap_predicate{stable p})

type farray (a:Type0) (n:nat) = x:t a n{witnessed (freezable_pred x)}  //an array that you intend to freeze in future

type array (a:Type0) (n:nat) = x:t a n{witnessed (mutable_pred x)}  //an array that you don't intend to freeze

(*
 * this is true if the current array has full view of the underlying array
 * we currently require freezing only on the full array
 *)
val is_full_array (#a:Type0) (#n:nat) (arr:t a n) : bool

(*
 * footprint of the array in the heap
 *)
val array_footprint (#a:Type0) (#n:nat) (arr:t a n) : GTot (Set.set nat)

(*
 * liveness of an array in the heap
 *)
val contains_array (#a:Type) (#n:nat) (h:heap) (arr:t a n) : Type0

(*
 * this is a precondition for writing, essentially, it will be false once you freeze the array
 *)
val is_mutable (#a:Type0) (#n:nat) (arr:t a n) (h:heap) : Type0

let fresh_arr (#a:Type0) (#n:nat) (arr:t a n) (h0 h1:heap)
  = h1 `contains_array` arr /\  //array is live in h1
    (forall (n:nat). Set.mem n (array_footprint arr) ==> n `addr_unused_in` h0)  //the footprint of array was unused in h0, hopefully this enables the clients to maintain separation

(*
 * create an array that you intend to freeze some time in future
 *)
val fcreate (a:Type0) (n:nat)
  :ST (farray a n) (requires (fun _         -> True))
                   (ensures  (fun h0 arr h1 -> fresh_arr arr h0 h1      /\  //it's fresh
		                            modifies Set.empty h0 h1 /\  //no existing refs are changed
					    is_mutable arr h1        /\  //the array is mutable
					    is_full_array arr))         //and has the full view of the underlying sequence

(*
 * create an array, that always remains mutable
 *)
val create (a:Type0) (n:nat)
  :ST (array a n) (requires (fun _         -> True))
                  (ensures  (fun h0 arr h1 -> fresh_arr arr h0 h1      /\  //it's fresh
		                           modifies Set.empty h0 h1 /\  //no existing refs are changed
					   is_full_array arr))         //and has the full view of the underlying sequence

(*
 * type of a valid index into an array
 *)
type index (#a:Type0) (#n:nat) (arr:t a n) = i:nat{i < n}

(*
 * Ghost view of an array as a sequence of options
 *)
val as_seq (#a:Type0) (#n:nat) (arr:t a n) (h:heap)
  :GTot (Seq.seq (option a))

val lemma_as_seq_length (#a:Type0) (#n:nat) (arr:t a n) (h:heap)
  :Lemma (requires True)
         (ensures  (Seq.length (as_seq arr h) = n))
	 [SMTPat (Seq.length (as_seq arr h))]

(* scaffolding for init_at *)
val init_at_arr (#a:Type0) (#n:nat) (arr:t a n) (i:index arr) (h:heap) : Type0

(* a stable initialized predicate *)
val initialized (#a:Type0) (#n:nat) (arr:t a n) (i:index arr) : (p:heap_predicate{stable p})

(* witnessed predicate for initialized *)
val init_at (#a:Type0) (#n:nat) (arr:t a n) (i:index arr) : Type0

(* scaffolding for frozen predicate *)
val frozen_bit (#a:Type0) (#n:nat) (arr:t a n) (h:heap) : Type0

open FStar.Ghost

(* a stable frozen predicate *)
val frozen_pred (#a:Type0) (#n:nat) (arr:t a n) (s:erased (Seq.seq a)) :(p:heap_predicate{stable p})

(* witnessed predicate for frozen *)
val frozen_with (#a:Type0) (#n:nat) (arr:t a n) (s:erased (Seq.seq a)) :Type0

(***** serious stuff starts now *****)

(*
 * freeze an array
 *)
val freeze (#a:Type0) (#n:nat) (arr:farray a n)
  :ST (erased (Seq.seq a))
      (requires (fun h0       -> is_full_array arr /\  //can only freeze full arrays
                              (forall (i:nat). i < n ==> init_at_arr arr i h0)))  //all elements must be init_at
      (ensures  (fun h0 es h1 -> some_equivalent_seqs (as_seq arr h0) (reveal es) /\  //the returned ghost sequence is the current view of array in the heap
                              frozen_with arr es                          /\  //witnessing the stable predicate
                              (~ (is_mutable arr h1))                     /\  //the array is no longer mutable
			      modifies (array_footprint arr) h0 h1))  //only array footprint is changed

(*
 * read from an array
 *)
val read (#a:Type0) (#n:nat) (arr:t a n) (i:index arr{arr `init_at` i})  //the index must be `init_at`
  :ST a (requires (fun h0      -> True))
        (ensures  (fun h0 r h1 -> h0 == h1 /\ Some r == Seq.index (as_seq arr h0) i))

val write (#a:Type0) (#n:nat) (arr:array a n) (i:nat{i < n}) (x:a)
  :ST unit (requires (fun h0       -> True))  //the array must be mutable
           (ensures  (fun h0 () h1 -> modifies (array_footprint arr) h0 h1 /\  //only array is modified
				   arr `init_at` i                      /\  //witness the stable init predicate
				   Seq.index (as_seq arr h1) i == Some x))  //update the ghost view of the array

(*
 * write into an array
 *)
val fwrite (#a:Type0) (#n:nat) (arr:farray a n) (i:nat{i < n}) (x:a)
  :ST unit (requires (fun h0       -> is_mutable arr h0))  //the array must be mutable
           (ensures  (fun h0 () h1 -> modifies (array_footprint arr) h0 h1 /\  //only array is modified
	                           is_mutable arr h1                    /\  //the array remains mutable
				   arr `init_at` i                      /\  //witness the stable init predicate
				   Seq.index (as_seq arr h1) i == Some x))  //update the ghost view of the array

(*
 * subarray
 *)
val sub (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n}) :t a len

let suffix (#a:Type0) (#n:nat) (arr:t a n) (i:nat{i <= n}) = sub arr i (n - i)
let prefix (#a:Type0) (#n:nat) (arr:t a n) (i:nat{i <= n}) = sub arr 0 i

val lemma_sub_preserves_array_mutable_flag (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n})
  :Lemma (requires (witnessed (mutable_pred arr)))
         (ensures  (witnessed (mutable_pred (sub arr i len))))
	 [SMTPat (witnessed (mutable_pred (sub arr i len)))]

val lemma_sub_preserves_array_freezable_flag (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n})
  :Lemma (requires (witnessed (freezable_pred arr)))
         (ensures  (witnessed (freezable_pred (sub arr i len))))
	 [SMTPat (witnessed (freezable_pred (sub arr i len)))]

val lemma_sub_is_slice (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n}) (h:heap)
  :Lemma (requires True)
         (ensures  (as_seq (sub arr i len) h == Seq.slice (as_seq arr h) i (i + len)))
	 [SMTPat (as_seq (sub arr i len) h)]

(*
 * footprint of a subarray is same as the footprint of the array
 *)
val lemma_sub_footprint
  (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n})
  :Lemma (requires True)
         (ensures (let arr' = sub arr i len in
                   array_footprint arr == array_footprint arr'))
	  [SMTPat (array_footprint (sub arr i len))]

(*
 * a subarray is live iff the array is live
 *)
val lemma_sub_contains
  (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n}) (h:heap)
  :Lemma (requires True)
         (ensures  (let arr' = sub arr i len in
	            h `contains_array` arr <==> h `contains_array` arr'))
         [SMTPat (h `contains_array` (sub arr i len))]

(*
 * a subarray is mutable iff the array is mutable
 *)
val lemma_sub_is_mutable
  (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n}) (h:heap)
  :Lemma (requires True)
         (ensures  (let arr' = sub arr i len in
	            is_mutable arr h <==> is_mutable arr' h))
         [SMTPat (is_mutable (sub arr i len) h)]

(*
 * subarray of a frozen array is frozen on a subsequence of the original sequence
 *)
val lemma_sub_frozen
  (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (len:nat{i + len <= n}) (es:erased (Seq.seq a){frozen_with arr es})
  :Lemma (requires (Seq.length (reveal es) == n))
         (ensures  (frozen_with (sub arr i len) (hide (Seq.slice (reveal es) i (i + len)))))
	 [SMTPat (frozen_with arr es); SMTPat (sub arr i len)]

(*
//  * if a subarray contains an init location, it remains init
//  *)
val lemma_sub_init_at
  (#a:Type0) (#n:nat) (arr:t a n) (i:index arr{arr `init_at` i})
  (j:index arr{j <= i}) (len:nat{j + len <= n /\ j + len > i})
  :Lemma (requires True)
         (ensures  ((sub arr j len) `init_at` (i - j)))
	 [SMTPat (arr `init_at` i); SMTPat (sub arr j len)]

(* recall various properties *)
val recall_init (#a:Type0) (#n:nat) (arr:t a n) (i:index arr{arr `init_at` i})
  :ST unit (requires (fun _       -> True))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ Some? (Seq.index (as_seq arr h0) i)))

val recall_frozen (#a:Type0) (#n:nat) (arr:t a n) (es:erased (Seq.seq a){frozen_with arr es})
  :ST unit (requires (fun _       -> True))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ some_equivalent_seqs (as_seq arr h0) (reveal es)))

val recall_contains (#a:Type0) (#n:nat) (arr:t a n)
  :ST unit (requires (fun _       -> True))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ h0 `contains_array` arr))

(* frozen implies init_at at all indices *)
val lemma_frozen_implies_init_at (#a:Type0) (#n:nat) (arr:t a n) (es:erased (Seq.seq a){frozen_with arr es}) (i:index arr)
  :Lemma (requires True)
         (ensures  (arr `init_at` i))
	 [SMTPat (frozen_with arr es); SMTPat (arr `init_at` i)]

(***** some utility functions *****)

let all_init_i_j (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (j:nat{j >= i /\ j <= n}) :Type0
  = forall (k:nat). k >= i /\ k < j ==> arr `init_at` k

let all_init (#a:Type0) (#n:nat) (arr:t a n) :Type0
  = all_init_i_j arr 0 n

let init_arr_in_heap_i_j (#a:Type0) (#n:nat) (arr:t a n) (h:heap) (i:nat) (j:nat{j >= i /\ j <= n}) :Type0
  = forall (k:nat). (k >= i /\ k < j) ==> init_at_seq (as_seq arr h) k

let init_arr_in_heap (#a:Type0) (#n:nat) (arr:t a n) (h:heap) :Type0
  = init_arr_in_heap_i_j arr h 0 n

val recall_all_init_i_j (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (j:nat{j >= i /\ j <= n /\ all_init_i_j arr i j})
  :ST unit (requires (fun _ -> True))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ init_arr_in_heap_i_j arr h0 i j))

val recall_all_init (#a:Type0) (#n:nat) (arr:t a n{all_init arr})
  :ST unit (requires (fun _ -> True))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ init_arr_in_heap arr h0))

val witness_all_init_i_j (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (j:nat{j >= i /\ j <= n})
  :ST unit (requires (fun h0      -> init_arr_in_heap_i_j arr h0 i j))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ all_init_i_j arr i j))

val witness_all_init (#a:Type0) (#n:nat) (arr:t a n)
  :ST unit (requires (fun h0 -> init_arr_in_heap arr h0))
           (ensures  (fun h0 _ h1 -> h0 == h1 /\ all_init arr))

let as_initialized_seq
  (#a:Type0) (#n:nat) (arr:t a n) (h:heap{init_arr_in_heap arr h})
  :GTot (seq a)
  = let s = as_seq arr h in
    get_some_equivalent s

let as_initialized_subseq (#a:Type0) (#n:nat) (arr:t a n) (h:heap)
  (i:nat) (j:nat{j >= i /\ j <= n /\ init_arr_in_heap_i_j arr h i j})
  :GTot (seq a)
  = let s = as_seq arr h in
    let s = Seq.slice s i j in
    get_some_equivalent s

val read_subseq_i_j (#a:Type0) (#n:nat) (arr:t a n) (i:nat) (j:nat{j >= i /\ j <= n})
  :ST (seq a)
      (requires (fun h0      -> all_init_i_j arr i j))
      (ensures  (fun h0 s h1 -> h0 == h1                        /\
                             init_arr_in_heap_i_j arr h0 i j /\
                             s == as_initialized_subseq arr h0 i j))
    
val lemma_framing_of_is_mutable (#a:Type0) (#n:nat) (arr:t a n) (h0:heap) (h1:heap) (r:Set.set nat)
  :Lemma (requires (modifies r h0 h1 /\ Set.disjoint r (array_footprint arr) /\ h0 `contains_array` arr))
         (ensures  ((is_mutable arr h0 <==> is_mutable arr h1) /\
	            (as_seq arr h0 == as_seq arr h1)))
	 [SMTPat (modifies r h0 h1); SMTPat (is_mutable arr h0)]

val lemma_framing_of_as_seq (#a:Type0) (#n:nat) (arr:t a n) (h0:heap) (h1:heap) (r:Set.set nat)
  :Lemma (requires (modifies r h0 h1 /\ Set.disjoint r (array_footprint arr) /\ h0 `contains_array` arr))
         (ensures  (as_seq arr h0 == as_seq arr h1))
	 [SMTPat (modifies r h0 h1); SMTPat (as_seq arr h0)]

val lemma_all_init_i_j_sub
  (#a:Type0) (#n:nat) (arr:t a n{all_init arr}) (i:nat) (len:nat{i + len <= n})
  :Lemma (requires True)
         (ensures  (all_init (sub arr i len)))
	 [SMTPat (all_init arr); SMTPat (sub arr i len)]

(***** disjointness *****)

val disjoint_sibling (#a:Type0) (#n1:nat) (#n2:nat) (arr1:t a n1) (arr2:t a n2) :Type0

val lemma_disjoint_sibling_suffix_prefix (#a:Type0) (#n:nat) (arr:t a n) (pos:nat{pos <= n})
  :Lemma (disjoint_sibling (prefix arr pos) (suffix arr pos) /\
          disjoint_sibling (suffix arr pos) (prefix arr pos))

let disjoint_siblings_remain_same (#a:Type0) (#n:nat) (arr:t a n) (h0 h1:heap)
  = forall (m:nat) (arr':t a m). disjoint_sibling arr arr' ==> (as_seq arr' h0 == as_seq arr' h1)

val lemma_disjoint_sibling_remain_same_for_unrelated_mods
  (#a:Type0) (#n:nat) (arr:t a n) (r:Set.set nat{Set.disjoint r (array_footprint arr)}) (h0:heap) (h1:heap{modifies r h0 h1})
  :Lemma (requires (h0 `contains_array` arr))
         (ensures (disjoint_siblings_remain_same arr h0 h1))

val lemma_disjoint_sibling_remain_same_transitive
  (#a:Type0) (#n:nat) (arr:t a n) (h0 h1 h2:heap)
  :Lemma (requires (disjoint_siblings_remain_same arr h0 h1 /\ disjoint_siblings_remain_same arr h1 h2))
         (ensures  (disjoint_siblings_remain_same arr h0 h2))

val fill (#a:Type0) (#n:nat) (arr:array a n) (buf:seq a{Seq.length buf <= n})
  :ST unit (requires (fun h0      -> True))
           (ensures  (fun h0 _ h1 -> modifies (array_footprint arr) h0 h1                   /\
	                          all_init_i_j arr 0 (Seq.length buf)                    /\
				  init_arr_in_heap_i_j arr h1 0 (Seq.length buf)         /\
				  buf == as_initialized_subseq arr h1 0 (Seq.length buf) /\
				  is_mutable arr h1                                      /\
				  disjoint_siblings_remain_same arr h0 h1))

val ffill (#a:Type0) (#n:nat) (arr:farray a n) (buf:seq a{Seq.length buf <= n})
  :ST unit (requires (fun h0      -> is_mutable arr h0))
           (ensures  (fun h0 _ h1 -> modifies (array_footprint arr) h0 h1                   /\
	                          all_init_i_j arr 0 (Seq.length buf)                    /\
				  init_arr_in_heap_i_j arr h1 0 (Seq.length buf)         /\
				  buf == as_initialized_subseq arr h1 0 (Seq.length buf) /\
				  is_mutable arr h1                                      /\
				  disjoint_siblings_remain_same arr h0 h1))
