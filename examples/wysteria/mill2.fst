(*--build-config
    options:--admit_fsi Set --admit_fsi Wysteria --codegen Wysteria;
    variables:LIB=../../lib;
    other-files:$LIB/ghost.fst $LIB/ext.fst $LIB/set.fsi $LIB/heap.fst $LIB/st.fst $LIB/all.fst wysteria.fsi
 --*)

(* Millionaire's with 2 parties, secure block as a separate function *)

module SMC

open Wysteria

let alice_s = singleton alice
let bob_s = singleton bob
let ab = union alice_s bob_s

type pre  (m:mode)  = fun m0 -> b2t (m0 = m)
type post (#a:Type) = fun (m:mode) (x:a) -> True

val read_fn: unit -> Wys nat (fun m0 -> Mode.m m0 = Par /\
                                        (exists p. Mode.ps m0 = singleton p))
                             (fun m0 r -> True)
let read_fn x = read #nat ()

val mill2_sec: x:Box int alice_s -> y:Box int bob_s -> Wys bool (pre (Mode Par ab)) post
let mill2_sec x y =
  let g:unit -> Wys bool (pre (Mode Sec ab)) post =
    fun _ -> (unbox_s x) > (unbox_s y)
  in
  as_sec ab g

val mill2: unit -> Wys bool (pre (Mode Par ab)) post
let mill2 _ =
  let x = as_par alice_s read_fn in
  let y = as_par bob_s read_fn in
  mill2_sec x y

;;

let x = main ab mill2 in
wprint x
