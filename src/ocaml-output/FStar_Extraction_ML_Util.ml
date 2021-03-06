open Prims
let (codegen_fsharp : unit -> Prims.bool) =
  fun uu____5  ->
    let uu____6 = FStar_Options.codegen ()  in
    uu____6 = (FStar_Pervasives_Native.Some FStar_Options.FSharp)
  
let pruneNones :
  'a . 'a FStar_Pervasives_Native.option Prims.list -> 'a Prims.list =
  fun l  ->
    FStar_List.fold_right
      (fun x  ->
         fun ll  ->
           match x with
           | FStar_Pervasives_Native.Some xs -> xs :: ll
           | FStar_Pervasives_Native.None  -> ll) l []
  
let (mk_range_mle : FStar_Extraction_ML_Syntax.mlexpr) =
  FStar_All.pipe_left
    (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top)
    (FStar_Extraction_ML_Syntax.MLE_Name (["Prims"], "mk_range"))
  
let (dummy_range_mle : FStar_Extraction_ML_Syntax.mlexpr) =
  FStar_All.pipe_left
    (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top)
    (FStar_Extraction_ML_Syntax.MLE_Name (["FStar"; "Range"], "dummyRange"))
  
let (mlconst_of_const' :
  FStar_Const.sconst -> FStar_Extraction_ML_Syntax.mlconstant) =
  fun sctt  ->
    match sctt with
    | FStar_Const.Const_effect  -> failwith "Unsupported constant"
    | FStar_Const.Const_range uu____75 -> FStar_Extraction_ML_Syntax.MLC_Unit
    | FStar_Const.Const_unit  -> FStar_Extraction_ML_Syntax.MLC_Unit
    | FStar_Const.Const_char c -> FStar_Extraction_ML_Syntax.MLC_Char c
    | FStar_Const.Const_int (s,i) ->
        FStar_Extraction_ML_Syntax.MLC_Int (s, i)
    | FStar_Const.Const_bool b -> FStar_Extraction_ML_Syntax.MLC_Bool b
    | FStar_Const.Const_float d -> FStar_Extraction_ML_Syntax.MLC_Float d
    | FStar_Const.Const_bytearray (bytes,uu____105) ->
        FStar_Extraction_ML_Syntax.MLC_Bytes bytes
    | FStar_Const.Const_string (s,uu____113) ->
        FStar_Extraction_ML_Syntax.MLC_String s
    | FStar_Const.Const_range_of  ->
        failwith "Unhandled constant: range_of/set_range_of"
    | FStar_Const.Const_set_range_of  ->
        failwith "Unhandled constant: range_of/set_range_of"
    | FStar_Const.Const_real uu____118 ->
        failwith "Unhandled constant: real/reify/reflect"
    | FStar_Const.Const_reify  ->
        failwith "Unhandled constant: real/reify/reflect"
    | FStar_Const.Const_reflect uu____122 ->
        failwith "Unhandled constant: real/reify/reflect"
  
let (mlconst_of_const :
  FStar_Range.range ->
    FStar_Const.sconst -> FStar_Extraction_ML_Syntax.mlconstant)
  =
  fun p  ->
    fun c  ->
      try (fun uu___51_136  -> match () with | () -> mlconst_of_const' c) ()
      with
      | uu___50_139 ->
          let uu____140 =
            let uu____142 = FStar_Range.string_of_range p  in
            let uu____144 = FStar_Syntax_Print.const_to_string c  in
            FStar_Util.format2 "(%s) Failed to translate constant %s "
              uu____142 uu____144
             in
          failwith uu____140
  
let (mlexpr_of_range :
  FStar_Range.range -> FStar_Extraction_ML_Syntax.mlexpr') =
  fun r  ->
    let cint i =
      let uu____161 =
        let uu____162 =
          let uu____163 =
            let uu____175 = FStar_Util.string_of_int i  in
            (uu____175, FStar_Pervasives_Native.None)  in
          FStar_Extraction_ML_Syntax.MLC_Int uu____163  in
        FStar_All.pipe_right uu____162
          (fun uu____188  -> FStar_Extraction_ML_Syntax.MLE_Const uu____188)
         in
      FStar_All.pipe_right uu____161
        (FStar_Extraction_ML_Syntax.with_ty
           FStar_Extraction_ML_Syntax.ml_int_ty)
       in
    let cstr s =
      let uu____197 =
        FStar_All.pipe_right (FStar_Extraction_ML_Syntax.MLC_String s)
          (fun uu____198  -> FStar_Extraction_ML_Syntax.MLE_Const uu____198)
         in
      FStar_All.pipe_right uu____197
        (FStar_Extraction_ML_Syntax.with_ty
           FStar_Extraction_ML_Syntax.ml_string_ty)
       in
    let uu____199 =
      let uu____206 =
        let uu____209 =
          let uu____210 = FStar_Range.file_of_range r  in
          FStar_All.pipe_right uu____210 cstr  in
        let uu____213 =
          let uu____216 =
            let uu____217 =
              let uu____219 = FStar_Range.start_of_range r  in
              FStar_All.pipe_right uu____219 FStar_Range.line_of_pos  in
            FStar_All.pipe_right uu____217 cint  in
          let uu____222 =
            let uu____225 =
              let uu____226 =
                let uu____228 = FStar_Range.start_of_range r  in
                FStar_All.pipe_right uu____228 FStar_Range.col_of_pos  in
              FStar_All.pipe_right uu____226 cint  in
            let uu____231 =
              let uu____234 =
                let uu____235 =
                  let uu____237 = FStar_Range.end_of_range r  in
                  FStar_All.pipe_right uu____237 FStar_Range.line_of_pos  in
                FStar_All.pipe_right uu____235 cint  in
              let uu____240 =
                let uu____243 =
                  let uu____244 =
                    let uu____246 = FStar_Range.end_of_range r  in
                    FStar_All.pipe_right uu____246 FStar_Range.col_of_pos  in
                  FStar_All.pipe_right uu____244 cint  in
                [uu____243]  in
              uu____234 :: uu____240  in
            uu____225 :: uu____231  in
          uu____216 :: uu____222  in
        uu____209 :: uu____213  in
      (mk_range_mle, uu____206)  in
    FStar_Extraction_ML_Syntax.MLE_App uu____199
  
let (mlexpr_of_const :
  FStar_Range.range ->
    FStar_Const.sconst -> FStar_Extraction_ML_Syntax.mlexpr')
  =
  fun p  ->
    fun c  ->
      match c with
      | FStar_Const.Const_range r -> mlexpr_of_range r
      | uu____263 ->
          let uu____264 = mlconst_of_const p c  in
          FStar_Extraction_ML_Syntax.MLE_Const uu____264
  
let rec (subst_aux :
  (FStar_Extraction_ML_Syntax.mlident * FStar_Extraction_ML_Syntax.mlty)
    Prims.list ->
    FStar_Extraction_ML_Syntax.mlty -> FStar_Extraction_ML_Syntax.mlty)
  =
  fun subst  ->
    fun t  ->
      match t with
      | FStar_Extraction_ML_Syntax.MLTY_Var x ->
          let uu____292 =
            FStar_Util.find_opt
              (fun uu____308  ->
                 match uu____308 with | (y,uu____316) -> y = x) subst
             in
          (match uu____292 with
           | FStar_Pervasives_Native.Some ts ->
               FStar_Pervasives_Native.snd ts
           | FStar_Pervasives_Native.None  -> t)
      | FStar_Extraction_ML_Syntax.MLTY_Fun (t1,f,t2) ->
          let uu____340 =
            let uu____347 = subst_aux subst t1  in
            let uu____348 = subst_aux subst t2  in (uu____347, f, uu____348)
             in
          FStar_Extraction_ML_Syntax.MLTY_Fun uu____340
      | FStar_Extraction_ML_Syntax.MLTY_Named (args,path) ->
          let uu____355 =
            let uu____362 = FStar_List.map (subst_aux subst) args  in
            (uu____362, path)  in
          FStar_Extraction_ML_Syntax.MLTY_Named uu____355
      | FStar_Extraction_ML_Syntax.MLTY_Tuple ts ->
          let uu____370 = FStar_List.map (subst_aux subst) ts  in
          FStar_Extraction_ML_Syntax.MLTY_Tuple uu____370
      | FStar_Extraction_ML_Syntax.MLTY_Top  -> t
      | FStar_Extraction_ML_Syntax.MLTY_Erased  -> t
  
let (try_subst :
  FStar_Extraction_ML_Syntax.mltyscheme ->
    FStar_Extraction_ML_Syntax.mlty Prims.list ->
      FStar_Extraction_ML_Syntax.mlty FStar_Pervasives_Native.option)
  =
  fun uu____386  ->
    fun args  ->
      match uu____386 with
      | (formals,t) ->
          if (FStar_List.length formals) <> (FStar_List.length args)
          then FStar_Pervasives_Native.None
          else
            (let uu____400 =
               let uu____401 = FStar_List.zip formals args  in
               subst_aux uu____401 t  in
             FStar_Pervasives_Native.Some uu____400)
  
let (subst :
  (FStar_Extraction_ML_Syntax.mlidents * FStar_Extraction_ML_Syntax.mlty) ->
    FStar_Extraction_ML_Syntax.mlty Prims.list ->
      FStar_Extraction_ML_Syntax.mlty)
  =
  fun ts  ->
    fun args  ->
      let uu____433 = try_subst ts args  in
      match uu____433 with
      | FStar_Pervasives_Native.None  ->
          failwith
            "Substitution must be fully applied (see GitHub issue #490)"
      | FStar_Pervasives_Native.Some t -> t
  
let (udelta_unfold :
  FStar_Extraction_ML_UEnv.uenv ->
    FStar_Extraction_ML_Syntax.mlty ->
      FStar_Extraction_ML_Syntax.mlty FStar_Pervasives_Native.option)
  =
  fun g  ->
    fun uu___0_450  ->
      match uu___0_450 with
      | FStar_Extraction_ML_Syntax.MLTY_Named (args,n) ->
          let uu____459 = FStar_Extraction_ML_UEnv.lookup_tydef g n  in
          (match uu____459 with
           | FStar_Pervasives_Native.Some ts ->
               let uu____465 = try_subst ts args  in
               (match uu____465 with
                | FStar_Pervasives_Native.None  ->
                    let uu____470 =
                      let uu____472 =
                        FStar_Extraction_ML_Syntax.string_of_mlpath n  in
                      let uu____474 =
                        FStar_Util.string_of_int (FStar_List.length args)  in
                      let uu____476 =
                        FStar_Util.string_of_int
                          (FStar_List.length (FStar_Pervasives_Native.fst ts))
                         in
                      FStar_Util.format3
                        "Substitution must be fully applied; got an application of %s with %s args whereas %s were expected (see GitHub issue #490)"
                        uu____472 uu____474 uu____476
                       in
                    failwith uu____470
                | FStar_Pervasives_Native.Some r ->
                    FStar_Pervasives_Native.Some r)
           | uu____483 -> FStar_Pervasives_Native.None)
      | uu____486 -> FStar_Pervasives_Native.None
  
let (eff_leq :
  FStar_Extraction_ML_Syntax.e_tag ->
    FStar_Extraction_ML_Syntax.e_tag -> Prims.bool)
  =
  fun f  ->
    fun f'  ->
      match (f, f') with
      | (FStar_Extraction_ML_Syntax.E_PURE ,uu____500) -> true
      | (FStar_Extraction_ML_Syntax.E_GHOST
         ,FStar_Extraction_ML_Syntax.E_GHOST ) -> true
      | (FStar_Extraction_ML_Syntax.E_IMPURE
         ,FStar_Extraction_ML_Syntax.E_IMPURE ) -> true
      | uu____504 -> false
  
let (eff_to_string : FStar_Extraction_ML_Syntax.e_tag -> Prims.string) =
  fun uu___1_516  ->
    match uu___1_516 with
    | FStar_Extraction_ML_Syntax.E_PURE  -> "Pure"
    | FStar_Extraction_ML_Syntax.E_GHOST  -> "Ghost"
    | FStar_Extraction_ML_Syntax.E_IMPURE  -> "Impure"
  
let (join :
  FStar_Range.range ->
    FStar_Extraction_ML_Syntax.e_tag ->
      FStar_Extraction_ML_Syntax.e_tag -> FStar_Extraction_ML_Syntax.e_tag)
  =
  fun r  ->
    fun f  ->
      fun f'  ->
        match (f, f') with
        | (FStar_Extraction_ML_Syntax.E_IMPURE
           ,FStar_Extraction_ML_Syntax.E_PURE ) ->
            FStar_Extraction_ML_Syntax.E_IMPURE
        | (FStar_Extraction_ML_Syntax.E_PURE
           ,FStar_Extraction_ML_Syntax.E_IMPURE ) ->
            FStar_Extraction_ML_Syntax.E_IMPURE
        | (FStar_Extraction_ML_Syntax.E_IMPURE
           ,FStar_Extraction_ML_Syntax.E_IMPURE ) ->
            FStar_Extraction_ML_Syntax.E_IMPURE
        | (FStar_Extraction_ML_Syntax.E_GHOST
           ,FStar_Extraction_ML_Syntax.E_GHOST ) ->
            FStar_Extraction_ML_Syntax.E_GHOST
        | (FStar_Extraction_ML_Syntax.E_PURE
           ,FStar_Extraction_ML_Syntax.E_GHOST ) ->
            FStar_Extraction_ML_Syntax.E_GHOST
        | (FStar_Extraction_ML_Syntax.E_GHOST
           ,FStar_Extraction_ML_Syntax.E_PURE ) ->
            FStar_Extraction_ML_Syntax.E_GHOST
        | (FStar_Extraction_ML_Syntax.E_PURE
           ,FStar_Extraction_ML_Syntax.E_PURE ) ->
            FStar_Extraction_ML_Syntax.E_PURE
        | uu____537 ->
            let uu____542 =
              let uu____544 = FStar_Range.string_of_range r  in
              let uu____546 = eff_to_string f  in
              let uu____548 = eff_to_string f'  in
              FStar_Util.format3
                "Impossible (%s): Inconsistent effects %s and %s" uu____544
                uu____546 uu____548
               in
            failwith uu____542
  
let (join_l :
  FStar_Range.range ->
    FStar_Extraction_ML_Syntax.e_tag Prims.list ->
      FStar_Extraction_ML_Syntax.e_tag)
  =
  fun r  ->
    fun fs  ->
      FStar_List.fold_left (join r) FStar_Extraction_ML_Syntax.E_PURE fs
  
let (mk_ty_fun :
  (FStar_Extraction_ML_Syntax.mlident * FStar_Extraction_ML_Syntax.mlty)
    Prims.list ->
    FStar_Extraction_ML_Syntax.mlty -> FStar_Extraction_ML_Syntax.mlty)
  =
  FStar_List.fold_right
    (fun uu____591  ->
       fun t  ->
         match uu____591 with
         | (uu____598,t0) ->
             FStar_Extraction_ML_Syntax.MLTY_Fun
               (t0, FStar_Extraction_ML_Syntax.E_PURE, t))
  
type unfold_t =
  FStar_Extraction_ML_Syntax.mlty ->
    FStar_Extraction_ML_Syntax.mlty FStar_Pervasives_Native.option
let rec (type_leq_c :
  unfold_t ->
    FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option ->
      FStar_Extraction_ML_Syntax.mlty ->
        FStar_Extraction_ML_Syntax.mlty ->
          (Prims.bool * FStar_Extraction_ML_Syntax.mlexpr
            FStar_Pervasives_Native.option))
  =
  fun unfold_ty  ->
    fun e  ->
      fun t  ->
        fun t'  ->
          match (t, t') with
          | (FStar_Extraction_ML_Syntax.MLTY_Var
             x,FStar_Extraction_ML_Syntax.MLTY_Var y) ->
              if x = y
              then (true, e)
              else (false, FStar_Pervasives_Native.None)
          | (FStar_Extraction_ML_Syntax.MLTY_Fun
             (t1,f,t2),FStar_Extraction_ML_Syntax.MLTY_Fun (t1',f',t2')) ->
              let mk_fun xs body =
                match xs with
                | [] -> body
                | uu____721 ->
                    let e1 =
                      match body.FStar_Extraction_ML_Syntax.expr with
                      | FStar_Extraction_ML_Syntax.MLE_Fun (ys,body1) ->
                          FStar_Extraction_ML_Syntax.MLE_Fun
                            ((FStar_List.append xs ys), body1)
                      | uu____758 ->
                          FStar_Extraction_ML_Syntax.MLE_Fun (xs, body)
                       in
                    let uu____766 =
                      mk_ty_fun xs body.FStar_Extraction_ML_Syntax.mlty  in
                    FStar_Extraction_ML_Syntax.with_ty uu____766 e1
                 in
              (match e with
               | FStar_Pervasives_Native.Some
                   {
                     FStar_Extraction_ML_Syntax.expr =
                       FStar_Extraction_ML_Syntax.MLE_Fun (x::xs,body);
                     FStar_Extraction_ML_Syntax.mlty = uu____777;
                     FStar_Extraction_ML_Syntax.loc = uu____778;_}
                   ->
                   let uu____803 =
                     (type_leq unfold_ty t1' t1) && (eff_leq f f')  in
                   if uu____803
                   then
                     (if
                        (f = FStar_Extraction_ML_Syntax.E_PURE) &&
                          (f' = FStar_Extraction_ML_Syntax.E_GHOST)
                      then
                        let uu____821 = type_leq unfold_ty t2 t2'  in
                        (if uu____821
                         then
                           let body1 =
                             let uu____832 =
                               type_leq unfold_ty t2
                                 FStar_Extraction_ML_Syntax.ml_unit_ty
                                in
                             if uu____832
                             then FStar_Extraction_ML_Syntax.ml_unit
                             else
                               FStar_All.pipe_left
                                 (FStar_Extraction_ML_Syntax.with_ty t2')
                                 (FStar_Extraction_ML_Syntax.MLE_Coerce
                                    (FStar_Extraction_ML_Syntax.ml_unit,
                                      FStar_Extraction_ML_Syntax.ml_unit_ty,
                                      t2'))
                              in
                           let uu____837 =
                             let uu____840 =
                               let uu____841 =
                                 let uu____846 =
                                   mk_ty_fun [x]
                                     body1.FStar_Extraction_ML_Syntax.mlty
                                    in
                                 FStar_Extraction_ML_Syntax.with_ty uu____846
                                  in
                               FStar_All.pipe_left uu____841
                                 (FStar_Extraction_ML_Syntax.MLE_Fun
                                    ([x], body1))
                                in
                             FStar_Pervasives_Native.Some uu____840  in
                           (true, uu____837)
                         else (false, FStar_Pervasives_Native.None))
                      else
                        (let uu____886 =
                           let uu____894 =
                             let uu____897 = mk_fun xs body  in
                             FStar_All.pipe_left
                               (fun uu____900  ->
                                  FStar_Pervasives_Native.Some uu____900)
                               uu____897
                              in
                           type_leq_c unfold_ty uu____894 t2 t2'  in
                         match uu____886 with
                         | (ok,body1) ->
                             let res =
                               match body1 with
                               | FStar_Pervasives_Native.Some body2 ->
                                   let uu____922 = mk_fun [x] body2  in
                                   FStar_Pervasives_Native.Some uu____922
                               | uu____933 -> FStar_Pervasives_Native.None
                                in
                             (ok, res)))
                   else (false, FStar_Pervasives_Native.None)
               | uu____945 ->
                   let uu____948 =
                     ((type_leq unfold_ty t1' t1) && (eff_leq f f')) &&
                       (type_leq unfold_ty t2 t2')
                      in
                   if uu____948
                   then (true, e)
                   else (false, FStar_Pervasives_Native.None))
          | (FStar_Extraction_ML_Syntax.MLTY_Named
             (args,path),FStar_Extraction_ML_Syntax.MLTY_Named (args',path'))
              ->
              if path = path'
              then
                let uu____988 =
                  FStar_List.forall2 (type_leq unfold_ty) args args'  in
                (if uu____988
                 then (true, e)
                 else (false, FStar_Pervasives_Native.None))
              else
                (let uu____1010 = unfold_ty t  in
                 match uu____1010 with
                 | FStar_Pervasives_Native.Some t1 ->
                     type_leq_c unfold_ty e t1 t'
                 | FStar_Pervasives_Native.None  ->
                     let uu____1021 = unfold_ty t'  in
                     (match uu____1021 with
                      | FStar_Pervasives_Native.None  ->
                          (false, FStar_Pervasives_Native.None)
                      | FStar_Pervasives_Native.Some t'1 ->
                          type_leq_c unfold_ty e t t'1))
          | (FStar_Extraction_ML_Syntax.MLTY_Tuple
             ts,FStar_Extraction_ML_Syntax.MLTY_Tuple ts') ->
              let uu____1042 = FStar_List.forall2 (type_leq unfold_ty) ts ts'
                 in
              if uu____1042
              then (true, e)
              else (false, FStar_Pervasives_Native.None)
          | (FStar_Extraction_ML_Syntax.MLTY_Top
             ,FStar_Extraction_ML_Syntax.MLTY_Top ) -> (true, e)
          | (FStar_Extraction_ML_Syntax.MLTY_Named uu____1066,uu____1067) ->
              let uu____1074 = unfold_ty t  in
              (match uu____1074 with
               | FStar_Pervasives_Native.Some t1 ->
                   type_leq_c unfold_ty e t1 t'
               | uu____1085 -> (false, FStar_Pervasives_Native.None))
          | (uu____1092,FStar_Extraction_ML_Syntax.MLTY_Named uu____1093) ->
              let uu____1100 = unfold_ty t'  in
              (match uu____1100 with
               | FStar_Pervasives_Native.Some t'1 ->
                   type_leq_c unfold_ty e t t'1
               | uu____1111 -> (false, FStar_Pervasives_Native.None))
          | (FStar_Extraction_ML_Syntax.MLTY_Erased
             ,FStar_Extraction_ML_Syntax.MLTY_Erased ) -> (true, e)
          | uu____1122 -> (false, FStar_Pervasives_Native.None)

and (type_leq :
  unfold_t ->
    FStar_Extraction_ML_Syntax.mlty ->
      FStar_Extraction_ML_Syntax.mlty -> Prims.bool)
  =
  fun g  ->
    fun t1  ->
      fun t2  ->
        let uu____1136 = type_leq_c g FStar_Pervasives_Native.None t1 t2  in
        FStar_All.pipe_right uu____1136 FStar_Pervasives_Native.fst

let rec (erase_effect_annotations :
  FStar_Extraction_ML_Syntax.mlty -> FStar_Extraction_ML_Syntax.mlty) =
  fun t  ->
    match t with
    | FStar_Extraction_ML_Syntax.MLTY_Fun (t1,f,t2) ->
        let uu____1164 =
          let uu____1171 = erase_effect_annotations t1  in
          let uu____1172 = erase_effect_annotations t2  in
          (uu____1171, FStar_Extraction_ML_Syntax.E_PURE, uu____1172)  in
        FStar_Extraction_ML_Syntax.MLTY_Fun uu____1164
    | uu____1173 -> t
  
let is_type_abstraction :
  'a 'b 'c . (('a,'b) FStar_Util.either * 'c) Prims.list -> Prims.bool =
  fun uu___2_1201  ->
    match uu___2_1201 with
    | (FStar_Util.Inl uu____1213,uu____1214)::uu____1215 -> true
    | uu____1239 -> false
  
let (is_xtuple :
  (Prims.string Prims.list * Prims.string) ->
    Prims.int FStar_Pervasives_Native.option)
  =
  fun uu____1267  ->
    match uu____1267 with
    | (ns,n) ->
        let uu____1289 =
          let uu____1291 = FStar_Util.concat_l "." (FStar_List.append ns [n])
             in
          FStar_Parser_Const.is_tuple_datacon_string uu____1291  in
        if uu____1289
        then
          let uu____1301 =
            let uu____1303 = FStar_Util.char_at n (Prims.of_int (7))  in
            FStar_Util.int_of_char uu____1303  in
          FStar_Pervasives_Native.Some uu____1301
        else FStar_Pervasives_Native.None
  
let (resugar_exp :
  FStar_Extraction_ML_Syntax.mlexpr -> FStar_Extraction_ML_Syntax.mlexpr) =
  fun e  ->
    match e.FStar_Extraction_ML_Syntax.expr with
    | FStar_Extraction_ML_Syntax.MLE_CTor (mlp,args) ->
        let uu____1322 = is_xtuple mlp  in
        (match uu____1322 with
         | FStar_Pervasives_Native.Some n ->
             FStar_All.pipe_left
               (FStar_Extraction_ML_Syntax.with_ty
                  e.FStar_Extraction_ML_Syntax.mlty)
               (FStar_Extraction_ML_Syntax.MLE_Tuple args)
         | uu____1329 -> e)
    | uu____1333 -> e
  
let (record_field_path :
  FStar_Ident.lident Prims.list -> Prims.string Prims.list) =
  fun uu___3_1344  ->
    match uu___3_1344 with
    | f::uu____1351 ->
        let uu____1354 =
          let uu____1361 = FStar_Ident.ns_of_lid f  in
          FStar_Util.prefix uu____1361  in
        (match uu____1354 with
         | (ns,uu____1368) ->
             FStar_All.pipe_right ns
               (FStar_List.map (fun id  -> FStar_Ident.text_of_id id)))
    | uu____1381 -> failwith "impos"
  
let record_fields :
  'a .
    FStar_Ident.lident Prims.list ->
      'a Prims.list -> (Prims.string * 'a) Prims.list
  =
  fun fs  ->
    fun vs  ->
      FStar_List.map2
        (fun f  ->
           fun e  ->
             let uu____1431 =
               let uu____1433 = FStar_Ident.ident_of_lid f  in
               FStar_Ident.text_of_id uu____1433  in
             (uu____1431, e)) fs vs
  
let (is_xtuple_ty :
  (Prims.string Prims.list * Prims.string) ->
    Prims.int FStar_Pervasives_Native.option)
  =
  fun uu____1451  ->
    match uu____1451 with
    | (ns,n) ->
        let uu____1473 =
          let uu____1475 = FStar_Util.concat_l "." (FStar_List.append ns [n])
             in
          FStar_Parser_Const.is_tuple_constructor_string uu____1475  in
        if uu____1473
        then
          let uu____1485 =
            let uu____1487 = FStar_Util.char_at n (Prims.of_int (5))  in
            FStar_Util.int_of_char uu____1487  in
          FStar_Pervasives_Native.Some uu____1485
        else FStar_Pervasives_Native.None
  
let (resugar_mlty :
  FStar_Extraction_ML_Syntax.mlty -> FStar_Extraction_ML_Syntax.mlty) =
  fun t  ->
    match t with
    | FStar_Extraction_ML_Syntax.MLTY_Named (args,mlp) ->
        let uu____1506 = is_xtuple_ty mlp  in
        (match uu____1506 with
         | FStar_Pervasives_Native.Some n ->
             FStar_Extraction_ML_Syntax.MLTY_Tuple args
         | uu____1513 -> t)
    | uu____1517 -> t
  
let (flatten_ns : Prims.string Prims.list -> Prims.string) =
  fun ns  ->
    let uu____1531 = codegen_fsharp ()  in
    if uu____1531
    then FStar_String.concat "." ns
    else FStar_String.concat "_" ns
  
let (flatten_mlpath :
  (Prims.string Prims.list * Prims.string) -> Prims.string) =
  fun uu____1553  ->
    match uu____1553 with
    | (ns,n) ->
        let uu____1573 = codegen_fsharp ()  in
        if uu____1573
        then FStar_String.concat "." (FStar_List.append ns [n])
        else FStar_String.concat "_" (FStar_List.append ns [n])
  
let (ml_module_name_of_lid : FStar_Ident.lident -> Prims.string) =
  fun l  ->
    let mlp =
      let uu____1603 =
        let uu____1607 = FStar_All.pipe_right l FStar_Ident.ns_of_lid  in
        FStar_All.pipe_right uu____1607
          (FStar_List.map FStar_Ident.text_of_id)
         in
      let uu____1618 =
        let uu____1620 = FStar_Ident.ident_of_lid l  in
        FStar_Ident.text_of_id uu____1620  in
      (uu____1603, uu____1618)  in
    flatten_mlpath mlp
  
let rec (erasableType :
  unfold_t -> FStar_Extraction_ML_Syntax.mlty -> Prims.bool) =
  fun unfold_ty  ->
    fun t  ->
      let erasableTypeNoDelta t1 =
        if t1 = FStar_Extraction_ML_Syntax.ml_unit_ty
        then true
        else
          (match t1 with
           | FStar_Extraction_ML_Syntax.MLTY_Named
               (uu____1653,("FStar"::"Ghost"::[],"erased")) -> true
           | FStar_Extraction_ML_Syntax.MLTY_Named
               (uu____1669,("FStar"::"Tactics"::"Effect"::[],"tactic")) ->
               let uu____1686 = FStar_Options.codegen ()  in
               uu____1686 <>
                 (FStar_Pervasives_Native.Some FStar_Options.Plugin)
           | uu____1691 -> false)
         in
      let uu____1693 = erasableTypeNoDelta t  in
      if uu____1693
      then true
      else
        (let uu____1700 = unfold_ty t  in
         match uu____1700 with
         | FStar_Pervasives_Native.Some t1 -> erasableType unfold_ty t1
         | FStar_Pervasives_Native.None  -> false)
  
let rec (eraseTypeDeep :
  unfold_t ->
    FStar_Extraction_ML_Syntax.mlty -> FStar_Extraction_ML_Syntax.mlty)
  =
  fun unfold_ty  ->
    fun t  ->
      match t with
      | FStar_Extraction_ML_Syntax.MLTY_Fun (tyd,etag,tycd) ->
          if etag = FStar_Extraction_ML_Syntax.E_PURE
          then
            let uu____1723 =
              let uu____1730 = eraseTypeDeep unfold_ty tyd  in
              let uu____1731 = eraseTypeDeep unfold_ty tycd  in
              (uu____1730, etag, uu____1731)  in
            FStar_Extraction_ML_Syntax.MLTY_Fun uu____1723
          else t
      | FStar_Extraction_ML_Syntax.MLTY_Named (lty,mlp) ->
          let uu____1740 = erasableType unfold_ty t  in
          if uu____1740
          then FStar_Extraction_ML_Syntax.MLTY_Erased
          else
            (let uu____1745 =
               let uu____1752 = FStar_List.map (eraseTypeDeep unfold_ty) lty
                  in
               (uu____1752, mlp)  in
             FStar_Extraction_ML_Syntax.MLTY_Named uu____1745)
      | FStar_Extraction_ML_Syntax.MLTY_Tuple lty ->
          let uu____1760 = FStar_List.map (eraseTypeDeep unfold_ty) lty  in
          FStar_Extraction_ML_Syntax.MLTY_Tuple uu____1760
      | uu____1763 -> t
  
let (prims_op_equality : FStar_Extraction_ML_Syntax.mlexpr) =
  FStar_All.pipe_left
    (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top)
    (FStar_Extraction_ML_Syntax.MLE_Name (["Prims"], "op_Equality"))
  
let (prims_op_amp_amp : FStar_Extraction_ML_Syntax.mlexpr) =
  let uu____1774 =
    let uu____1779 =
      mk_ty_fun
        [("x", FStar_Extraction_ML_Syntax.ml_bool_ty);
        ("y", FStar_Extraction_ML_Syntax.ml_bool_ty)]
        FStar_Extraction_ML_Syntax.ml_bool_ty
       in
    FStar_Extraction_ML_Syntax.with_ty uu____1779  in
  FStar_All.pipe_left uu____1774
    (FStar_Extraction_ML_Syntax.MLE_Name (["Prims"], "op_AmpAmp"))
  
let (conjoin :
  FStar_Extraction_ML_Syntax.mlexpr ->
    FStar_Extraction_ML_Syntax.mlexpr -> FStar_Extraction_ML_Syntax.mlexpr)
  =
  fun e1  ->
    fun e2  ->
      FStar_All.pipe_left
        (FStar_Extraction_ML_Syntax.with_ty
           FStar_Extraction_ML_Syntax.ml_bool_ty)
        (FStar_Extraction_ML_Syntax.MLE_App (prims_op_amp_amp, [e1; e2]))
  
let (conjoin_opt :
  FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option ->
    FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option ->
      FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option)
  =
  fun e1  ->
    fun e2  ->
      match (e1, e2) with
      | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.None ) ->
          FStar_Pervasives_Native.None
      | (FStar_Pervasives_Native.Some x,FStar_Pervasives_Native.None ) ->
          FStar_Pervasives_Native.Some x
      | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.Some x) ->
          FStar_Pervasives_Native.Some x
      | (FStar_Pervasives_Native.Some x,FStar_Pervasives_Native.Some y) ->
          let uu____1867 = conjoin x y  in
          FStar_Pervasives_Native.Some uu____1867
  
let (mlloc_of_range : FStar_Range.range -> (Prims.int * Prims.string)) =
  fun r  ->
    let pos = FStar_Range.start_of_range r  in
    let line = FStar_Range.line_of_pos pos  in
    let uu____1883 = FStar_Range.file_of_range r  in (line, uu____1883)
  
let rec (doms_and_cod :
  FStar_Extraction_ML_Syntax.mlty ->
    (FStar_Extraction_ML_Syntax.mlty Prims.list *
      FStar_Extraction_ML_Syntax.mlty))
  =
  fun t  ->
    match t with
    | FStar_Extraction_ML_Syntax.MLTY_Fun (a,uu____1906,b) ->
        let uu____1908 = doms_and_cod b  in
        (match uu____1908 with | (ds,c) -> ((a :: ds), c))
    | uu____1929 -> ([], t)
  
let (argTypes :
  FStar_Extraction_ML_Syntax.mlty ->
    FStar_Extraction_ML_Syntax.mlty Prims.list)
  =
  fun t  ->
    let uu____1942 = doms_and_cod t  in
    FStar_Pervasives_Native.fst uu____1942
  
let rec (uncurry_mlty_fun :
  FStar_Extraction_ML_Syntax.mlty ->
    (FStar_Extraction_ML_Syntax.mlty Prims.list *
      FStar_Extraction_ML_Syntax.mlty))
  =
  fun t  ->
    match t with
    | FStar_Extraction_ML_Syntax.MLTY_Fun (a,uu____1970,b) ->
        let uu____1972 = uncurry_mlty_fun b  in
        (match uu____1972 with | (args,res) -> ((a :: args), res))
    | uu____1993 -> ([], t)
  
exception NoTacticEmbedding of Prims.string 
let (uu___is_NoTacticEmbedding : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | NoTacticEmbedding uu____2009 -> true
    | uu____2012 -> false
  
let (__proj__NoTacticEmbedding__item__uu___ : Prims.exn -> Prims.string) =
  fun projectee  ->
    match projectee with | NoTacticEmbedding uu____2022 -> uu____2022
  
let (not_implemented_warning :
  FStar_Range.range -> Prims.string -> Prims.string -> unit) =
  fun r  ->
    fun t  ->
      fun msg  ->
        let uu____2044 =
          let uu____2050 =
            FStar_Util.format2
              "Plugin %s will not run natively because %s.\n" t msg
             in
          (FStar_Errors.Warning_CallNotImplementedAsWarning, uu____2050)  in
        FStar_Errors.log_issue r uu____2044
  
type emb_loc =
  | Syntax_term 
  | Refl_emb 
  | NBE_t 
  | NBERefl_emb 
let (uu___is_Syntax_term : emb_loc -> Prims.bool) =
  fun projectee  ->
    match projectee with | Syntax_term  -> true | uu____2063 -> false
  
let (uu___is_Refl_emb : emb_loc -> Prims.bool) =
  fun projectee  ->
    match projectee with | Refl_emb  -> true | uu____2074 -> false
  
let (uu___is_NBE_t : emb_loc -> Prims.bool) =
  fun projectee  ->
    match projectee with | NBE_t  -> true | uu____2085 -> false
  
let (uu___is_NBERefl_emb : emb_loc -> Prims.bool) =
  fun projectee  ->
    match projectee with | NBERefl_emb  -> true | uu____2096 -> false
  
type wrapped_term =
  (FStar_Extraction_ML_Syntax.mlexpr * FStar_Extraction_ML_Syntax.mlexpr *
    Prims.int * Prims.bool)
let (interpret_plugin_as_term_fun :
  FStar_Extraction_ML_UEnv.uenv ->
    FStar_Syntax_Syntax.fv ->
      FStar_Syntax_Syntax.typ ->
        Prims.int FStar_Pervasives_Native.option ->
          FStar_Extraction_ML_Syntax.mlexpr' ->
            (FStar_Extraction_ML_Syntax.mlexpr *
              FStar_Extraction_ML_Syntax.mlexpr * Prims.int * Prims.bool)
              FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun fv  ->
      fun t  ->
        fun arity_opt  ->
          fun ml_fv  ->
            let fv_lid =
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v  in
            let tcenv = FStar_Extraction_ML_UEnv.tcenv_of_uenv env  in
            let t1 =
              FStar_TypeChecker_Normalize.normalize
                [FStar_TypeChecker_Env.EraseUniverses;
                FStar_TypeChecker_Env.AllowUnboundUniverses;
                FStar_TypeChecker_Env.UnfoldUntil
                  FStar_Syntax_Syntax.delta_constant] tcenv t
               in
            let w =
              FStar_Extraction_ML_Syntax.with_ty
                FStar_Extraction_ML_Syntax.MLTY_Top
               in
            let as_name mlp =
              FStar_All.pipe_left
                (FStar_Extraction_ML_Syntax.with_ty
                   FStar_Extraction_ML_Syntax.MLTY_Top)
                (FStar_Extraction_ML_Syntax.MLE_Name mlp)
               in
            let lid_to_name l =
              let uu____2174 =
                let uu____2175 =
                  FStar_Extraction_ML_UEnv.mlpath_of_lident env l  in
                FStar_Extraction_ML_Syntax.MLE_Name uu____2175  in
              FStar_All.pipe_left
                (FStar_Extraction_ML_Syntax.with_ty
                   FStar_Extraction_ML_Syntax.MLTY_Top) uu____2174
               in
            let str_to_name s = as_name ([], s)  in
            let fstar_tc_nbe_prefix s =
              as_name (["FStar_TypeChecker_NBETerm"], s)  in
            let fstar_syn_emb_prefix s =
              as_name (["FStar_Syntax_Embeddings"], s)  in
            let fstar_refl_emb_prefix s =
              as_name (["FStar_Reflection_Embeddings"], s)  in
            let fstar_refl_nbeemb_prefix s =
              as_name (["FStar_Reflection_NBEEmbeddings"], s)  in
            let fv_lid_embedded =
              let uu____2250 =
                let uu____2251 =
                  let uu____2258 = as_name (["FStar_Ident"], "lid_of_str")
                     in
                  let uu____2267 =
                    let uu____2270 =
                      let uu____2271 =
                        let uu____2272 =
                          let uu____2273 = FStar_Ident.string_of_lid fv_lid
                             in
                          FStar_Extraction_ML_Syntax.MLC_String uu____2273
                           in
                        FStar_Extraction_ML_Syntax.MLE_Const uu____2272  in
                      FStar_All.pipe_left
                        (FStar_Extraction_ML_Syntax.with_ty
                           FStar_Extraction_ML_Syntax.MLTY_Top) uu____2271
                       in
                    [uu____2270]  in
                  (uu____2258, uu____2267)  in
                FStar_Extraction_ML_Syntax.MLE_App uu____2251  in
              FStar_All.pipe_left
                (FStar_Extraction_ML_Syntax.with_ty
                   FStar_Extraction_ML_Syntax.MLTY_Top) uu____2250
               in
            let emb_prefix uu___4_2288 =
              match uu___4_2288 with
              | Syntax_term  -> fstar_syn_emb_prefix
              | Refl_emb  -> fstar_refl_emb_prefix
              | NBE_t  -> fstar_tc_nbe_prefix
              | NBERefl_emb  -> fstar_refl_nbeemb_prefix  in
            let mk_tactic_interpretation l arity =
              let idroot =
                match l with
                | Syntax_term  -> "mk_tactic_interpretation_"
                | uu____2310 -> "mk_nbe_tactic_interpretation_"  in
              let uu____2312 =
                let uu____2313 =
                  let uu____2315 = FStar_Util.string_of_int arity  in
                  Prims.op_Hat idroot uu____2315  in
                (["FStar_Tactics_InterpFuns"], uu____2313)  in
              as_name uu____2312  in
            let mk_from_tactic l arity =
              let idroot =
                match l with
                | Syntax_term  -> "from_tactic_"
                | uu____2341 -> "from_nbe_tactic_"  in
              let uu____2343 =
                let uu____2344 =
                  let uu____2346 = FStar_Util.string_of_int arity  in
                  Prims.op_Hat idroot uu____2346  in
                (["FStar_Tactics_Native"], uu____2344)  in
              as_name uu____2343  in
            let mk_basic_embedding l s = emb_prefix l (Prims.op_Hat "e_" s)
               in
            let mk_arrow_as_prim_step l arity =
              let uu____2382 =
                let uu____2384 = FStar_Util.string_of_int arity  in
                Prims.op_Hat "arrow_as_prim_step_" uu____2384  in
              emb_prefix l uu____2382  in
            let mk_any_embedding l s =
              let uu____2400 =
                let uu____2401 =
                  let uu____2408 = emb_prefix l "mk_any_emb"  in
                  let uu____2410 =
                    let uu____2413 = str_to_name s  in [uu____2413]  in
                  (uu____2408, uu____2410)  in
                FStar_Extraction_ML_Syntax.MLE_App uu____2401  in
              FStar_All.pipe_left w uu____2400  in
            let mk_lam nm e =
              FStar_All.pipe_left w
                (FStar_Extraction_ML_Syntax.MLE_Fun
                   ([(nm, FStar_Extraction_ML_Syntax.MLTY_Top)], e))
               in
            let emb_arrow l e1 e2 =
              let uu____2463 =
                let uu____2464 =
                  let uu____2471 = emb_prefix l "e_arrow"  in
                  (uu____2471, [e1; e2])  in
                FStar_Extraction_ML_Syntax.MLE_App uu____2464  in
              FStar_All.pipe_left w uu____2463  in
            let known_type_constructors =
              let term_cs =
                let uu____2509 =
                  let uu____2524 =
                    let uu____2539 =
                      let uu____2554 =
                        let uu____2569 =
                          let uu____2584 =
                            let uu____2599 =
                              let uu____2614 =
                                let uu____2627 =
                                  let uu____2636 =
                                    FStar_Parser_Const.mk_tuple_lid
                                      (Prims.of_int (2))
                                      FStar_Range.dummyRange
                                     in
                                  (uu____2636, (Prims.of_int (2)), "tuple2")
                                   in
                                (uu____2627, Syntax_term)  in
                              let uu____2650 =
                                let uu____2665 =
                                  let uu____2678 =
                                    let uu____2687 =
                                      FStar_Reflection_Data.fstar_refl_types_lid
                                        "term"
                                       in
                                    (uu____2687, Prims.int_zero, "term")  in
                                  (uu____2678, Refl_emb)  in
                                let uu____2701 =
                                  let uu____2716 =
                                    let uu____2729 =
                                      let uu____2738 =
                                        FStar_Reflection_Data.fstar_refl_types_lid
                                          "sigelt"
                                         in
                                      (uu____2738, Prims.int_zero, "sigelt")
                                       in
                                    (uu____2729, Refl_emb)  in
                                  let uu____2752 =
                                    let uu____2767 =
                                      let uu____2780 =
                                        let uu____2789 =
                                          FStar_Reflection_Data.fstar_refl_types_lid
                                            "fv"
                                           in
                                        (uu____2789, Prims.int_zero, "fv")
                                         in
                                      (uu____2780, Refl_emb)  in
                                    let uu____2803 =
                                      let uu____2818 =
                                        let uu____2831 =
                                          let uu____2840 =
                                            FStar_Reflection_Data.fstar_refl_types_lid
                                              "binder"
                                             in
                                          (uu____2840, Prims.int_zero,
                                            "binder")
                                           in
                                        (uu____2831, Refl_emb)  in
                                      let uu____2854 =
                                        let uu____2869 =
                                          let uu____2882 =
                                            let uu____2891 =
                                              FStar_Reflection_Data.fstar_refl_syntax_lid
                                                "binders"
                                               in
                                            (uu____2891, Prims.int_zero,
                                              "binders")
                                             in
                                          (uu____2882, Refl_emb)  in
                                        let uu____2905 =
                                          let uu____2920 =
                                            let uu____2933 =
                                              let uu____2942 =
                                                FStar_Reflection_Data.fstar_refl_data_lid
                                                  "exp"
                                                 in
                                              (uu____2942, Prims.int_zero,
                                                "exp")
                                               in
                                            (uu____2933, Refl_emb)  in
                                          [uu____2920]  in
                                        uu____2869 :: uu____2905  in
                                      uu____2818 :: uu____2854  in
                                    uu____2767 :: uu____2803  in
                                  uu____2716 :: uu____2752  in
                                uu____2665 :: uu____2701  in
                              uu____2614 :: uu____2650  in
                            ((FStar_Parser_Const.option_lid, Prims.int_one,
                               "option"), Syntax_term)
                              :: uu____2599
                             in
                          ((FStar_Parser_Const.list_lid, Prims.int_one,
                             "list"), Syntax_term)
                            :: uu____2584
                           in
                        ((FStar_Parser_Const.norm_step_lid, Prims.int_zero,
                           "norm_step"), Syntax_term)
                          :: uu____2569
                         in
                      ((FStar_Parser_Const.string_lid, Prims.int_zero,
                         "string"), Syntax_term)
                        :: uu____2554
                       in
                    ((FStar_Parser_Const.unit_lid, Prims.int_zero, "unit"),
                      Syntax_term) :: uu____2539
                     in
                  ((FStar_Parser_Const.bool_lid, Prims.int_zero, "bool"),
                    Syntax_term) :: uu____2524
                   in
                ((FStar_Parser_Const.int_lid, Prims.int_zero, "int"),
                  Syntax_term) :: uu____2509
                 in
              let nbe_cs =
                FStar_List.map
                  (fun uu___5_3261  ->
                     match uu___5_3261 with
                     | (x,Syntax_term ) -> (x, NBE_t)
                     | (x,Refl_emb ) -> (x, NBERefl_emb)
                     | uu____3336 -> failwith "Impossible") term_cs
                 in
              fun uu___6_3362  ->
                match uu___6_3362 with
                | Syntax_term  -> term_cs
                | Refl_emb  -> term_cs
                | uu____3377 -> nbe_cs
               in
            let is_known_type_constructor l fv1 n =
              FStar_Util.for_some
                (fun uu____3414  ->
                   match uu____3414 with
                   | ((x,args,uu____3430),uu____3431) ->
                       (FStar_Syntax_Syntax.fv_eq_lid fv1 x) && (n = args))
                (known_type_constructors l)
               in
            let find_env_entry bv uu____3461 =
              match uu____3461 with
              | (bv',uu____3469) -> FStar_Syntax_Syntax.bv_eq bv bv'  in
            let rec mk_embedding l env1 t2 =
              let t3 = FStar_TypeChecker_Normalize.unfold_whnf tcenv t2  in
              let uu____3503 =
                let uu____3504 = FStar_Syntax_Subst.compress t3  in
                uu____3504.FStar_Syntax_Syntax.n  in
              match uu____3503 with
              | FStar_Syntax_Syntax.Tm_name bv when
                  FStar_Util.for_some (find_env_entry bv) env1 ->
                  let uu____3513 =
                    let uu____3515 =
                      let uu____3521 =
                        FStar_Util.find_opt (find_env_entry bv) env1  in
                      FStar_Util.must uu____3521  in
                    FStar_Pervasives_Native.snd uu____3515  in
                  FStar_All.pipe_left (mk_any_embedding l) uu____3513
              | FStar_Syntax_Syntax.Tm_refine (x,uu____3542) ->
                  mk_embedding l env1 x.FStar_Syntax_Syntax.sort
              | FStar_Syntax_Syntax.Tm_ascribed (t4,uu____3548,uu____3549) ->
                  mk_embedding l env1 t4
              | FStar_Syntax_Syntax.Tm_arrow (b::[],c) when
                  FStar_Syntax_Util.is_pure_comp c ->
                  let uu____3622 = FStar_Syntax_Subst.open_comp [b] c  in
                  (match uu____3622 with
                   | (bs,c1) ->
                       let t0 =
                         let uu____3644 =
                           let uu____3645 = FStar_List.hd bs  in
                           FStar_Pervasives_Native.fst uu____3645  in
                         uu____3644.FStar_Syntax_Syntax.sort  in
                       let t11 = FStar_Syntax_Util.comp_result c1  in
                       let uu____3663 = mk_embedding l env1 t0  in
                       let uu____3664 = mk_embedding l env1 t11  in
                       emb_arrow l uu____3663 uu____3664)
              | FStar_Syntax_Syntax.Tm_arrow (b::more::bs,c) ->
                  let tail =
                    FStar_Syntax_Syntax.mk
                      (FStar_Syntax_Syntax.Tm_arrow ((more :: bs), c))
                      FStar_Pervasives_Native.None t3.FStar_Syntax_Syntax.pos
                     in
                  let t4 =
                    let uu____3735 =
                      let uu____3742 =
                        let uu____3743 =
                          let uu____3758 = FStar_Syntax_Syntax.mk_Total tail
                             in
                          ([b], uu____3758)  in
                        FStar_Syntax_Syntax.Tm_arrow uu____3743  in
                      FStar_Syntax_Syntax.mk uu____3742  in
                    uu____3735 FStar_Pervasives_Native.None
                      t3.FStar_Syntax_Syntax.pos
                     in
                  mk_embedding l env1 t4
              | FStar_Syntax_Syntax.Tm_fvar uu____3783 ->
                  let uu____3784 = FStar_Syntax_Util.head_and_args t3  in
                  (match uu____3784 with
                   | (head,args) ->
                       let n_args = FStar_List.length args  in
                       let uu____3836 =
                         let uu____3837 = FStar_Syntax_Util.un_uinst head  in
                         uu____3837.FStar_Syntax_Syntax.n  in
                       (match uu____3836 with
                        | FStar_Syntax_Syntax.Tm_fvar fv1 when
                            is_known_type_constructor l fv1 n_args ->
                            let arg_embeddings =
                              FStar_All.pipe_right args
                                (FStar_List.map
                                   (fun uu____3863  ->
                                      match uu____3863 with
                                      | (t4,uu____3871) ->
                                          mk_embedding l env1 t4))
                               in
                            let nm =
                              let uu____3878 =
                                FStar_Ident.ident_of_lid
                                  (fv1.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                 in
                              FStar_Ident.text_of_id uu____3878  in
                            let uu____3879 =
                              let uu____3892 =
                                FStar_Util.find_opt
                                  (fun uu____3924  ->
                                     match uu____3924 with
                                     | ((x,uu____3939,uu____3940),uu____3941)
                                         ->
                                         FStar_Syntax_Syntax.fv_eq_lid fv1 x)
                                  (known_type_constructors l)
                                 in
                              FStar_All.pipe_right uu____3892 FStar_Util.must
                               in
                            (match uu____3879 with
                             | ((uu____3992,t_arity,_trepr_head),loc_embedding)
                                 ->
                                 let head1 =
                                   mk_basic_embedding loc_embedding nm  in
                                 (match t_arity with
                                  | uu____4009 when
                                      uu____4009 = Prims.int_zero -> head1
                                  | n ->
                                      FStar_All.pipe_left w
                                        (FStar_Extraction_ML_Syntax.MLE_App
                                           (head1, arg_embeddings))))
                        | uu____4014 ->
                            let uu____4015 =
                              let uu____4016 =
                                let uu____4018 =
                                  FStar_Syntax_Print.term_to_string t3  in
                                Prims.op_Hat
                                  "Embedding not defined for type "
                                  uu____4018
                                 in
                              NoTacticEmbedding uu____4016  in
                            FStar_Exn.raise uu____4015))
              | FStar_Syntax_Syntax.Tm_uinst uu____4021 ->
                  let uu____4028 = FStar_Syntax_Util.head_and_args t3  in
                  (match uu____4028 with
                   | (head,args) ->
                       let n_args = FStar_List.length args  in
                       let uu____4080 =
                         let uu____4081 = FStar_Syntax_Util.un_uinst head  in
                         uu____4081.FStar_Syntax_Syntax.n  in
                       (match uu____4080 with
                        | FStar_Syntax_Syntax.Tm_fvar fv1 when
                            is_known_type_constructor l fv1 n_args ->
                            let arg_embeddings =
                              FStar_All.pipe_right args
                                (FStar_List.map
                                   (fun uu____4107  ->
                                      match uu____4107 with
                                      | (t4,uu____4115) ->
                                          mk_embedding l env1 t4))
                               in
                            let nm =
                              let uu____4122 =
                                FStar_Ident.ident_of_lid
                                  (fv1.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                 in
                              FStar_Ident.text_of_id uu____4122  in
                            let uu____4123 =
                              let uu____4136 =
                                FStar_Util.find_opt
                                  (fun uu____4168  ->
                                     match uu____4168 with
                                     | ((x,uu____4183,uu____4184),uu____4185)
                                         ->
                                         FStar_Syntax_Syntax.fv_eq_lid fv1 x)
                                  (known_type_constructors l)
                                 in
                              FStar_All.pipe_right uu____4136 FStar_Util.must
                               in
                            (match uu____4123 with
                             | ((uu____4236,t_arity,_trepr_head),loc_embedding)
                                 ->
                                 let head1 =
                                   mk_basic_embedding loc_embedding nm  in
                                 (match t_arity with
                                  | uu____4253 when
                                      uu____4253 = Prims.int_zero -> head1
                                  | n ->
                                      FStar_All.pipe_left w
                                        (FStar_Extraction_ML_Syntax.MLE_App
                                           (head1, arg_embeddings))))
                        | uu____4258 ->
                            let uu____4259 =
                              let uu____4260 =
                                let uu____4262 =
                                  FStar_Syntax_Print.term_to_string t3  in
                                Prims.op_Hat
                                  "Embedding not defined for type "
                                  uu____4262
                                 in
                              NoTacticEmbedding uu____4260  in
                            FStar_Exn.raise uu____4259))
              | FStar_Syntax_Syntax.Tm_app uu____4265 ->
                  let uu____4282 = FStar_Syntax_Util.head_and_args t3  in
                  (match uu____4282 with
                   | (head,args) ->
                       let n_args = FStar_List.length args  in
                       let uu____4334 =
                         let uu____4335 = FStar_Syntax_Util.un_uinst head  in
                         uu____4335.FStar_Syntax_Syntax.n  in
                       (match uu____4334 with
                        | FStar_Syntax_Syntax.Tm_fvar fv1 when
                            is_known_type_constructor l fv1 n_args ->
                            let arg_embeddings =
                              FStar_All.pipe_right args
                                (FStar_List.map
                                   (fun uu____4361  ->
                                      match uu____4361 with
                                      | (t4,uu____4369) ->
                                          mk_embedding l env1 t4))
                               in
                            let nm =
                              let uu____4376 =
                                FStar_Ident.ident_of_lid
                                  (fv1.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                 in
                              FStar_Ident.text_of_id uu____4376  in
                            let uu____4377 =
                              let uu____4390 =
                                FStar_Util.find_opt
                                  (fun uu____4422  ->
                                     match uu____4422 with
                                     | ((x,uu____4437,uu____4438),uu____4439)
                                         ->
                                         FStar_Syntax_Syntax.fv_eq_lid fv1 x)
                                  (known_type_constructors l)
                                 in
                              FStar_All.pipe_right uu____4390 FStar_Util.must
                               in
                            (match uu____4377 with
                             | ((uu____4490,t_arity,_trepr_head),loc_embedding)
                                 ->
                                 let head1 =
                                   mk_basic_embedding loc_embedding nm  in
                                 (match t_arity with
                                  | uu____4507 when
                                      uu____4507 = Prims.int_zero -> head1
                                  | n ->
                                      FStar_All.pipe_left w
                                        (FStar_Extraction_ML_Syntax.MLE_App
                                           (head1, arg_embeddings))))
                        | uu____4512 ->
                            let uu____4513 =
                              let uu____4514 =
                                let uu____4516 =
                                  FStar_Syntax_Print.term_to_string t3  in
                                Prims.op_Hat
                                  "Embedding not defined for type "
                                  uu____4516
                                 in
                              NoTacticEmbedding uu____4514  in
                            FStar_Exn.raise uu____4513))
              | uu____4519 ->
                  let uu____4520 =
                    let uu____4521 =
                      let uu____4523 = FStar_Syntax_Print.term_to_string t3
                         in
                      Prims.op_Hat "Embedding not defined for type "
                        uu____4523
                       in
                    NoTacticEmbedding uu____4521  in
                  FStar_Exn.raise uu____4520
               in
            let abstract_tvars tvar_names body =
              match tvar_names with
              | [] ->
                  let body1 =
                    let uu____4545 =
                      let uu____4546 =
                        let uu____4553 =
                          as_name (["FStar_Syntax_Embeddings"], "debug_wrap")
                           in
                        let uu____4562 =
                          let uu____4565 =
                            let uu____4566 =
                              let uu____4567 =
                                let uu____4568 =
                                  FStar_Ident.string_of_lid fv_lid  in
                                FStar_Extraction_ML_Syntax.MLC_String
                                  uu____4568
                                 in
                              FStar_Extraction_ML_Syntax.MLE_Const uu____4567
                               in
                            FStar_All.pipe_left
                              (FStar_Extraction_ML_Syntax.with_ty
                                 FStar_Extraction_ML_Syntax.MLTY_Top)
                              uu____4566
                             in
                          let uu____4570 =
                            let uu____4573 =
                              let uu____4574 =
                                let uu____4575 =
                                  let uu____4576 =
                                    let uu____4583 =
                                      let uu____4586 = str_to_name "args"  in
                                      [uu____4586]  in
                                    (body, uu____4583)  in
                                  FStar_Extraction_ML_Syntax.MLE_App
                                    uu____4576
                                   in
                                FStar_All.pipe_left w uu____4575  in
                              mk_lam "_" uu____4574  in
                            [uu____4573]  in
                          uu____4565 :: uu____4570  in
                        (uu____4553, uu____4562)  in
                      FStar_Extraction_ML_Syntax.MLE_App uu____4546  in
                    FStar_All.pipe_left w uu____4545  in
                  mk_lam "args" body1
              | uu____4594 ->
                  let args_tail =
                    FStar_Extraction_ML_Syntax.MLP_Var "args_tail"  in
                  let mk_cons hd_pat tail_pat =
                    FStar_Extraction_ML_Syntax.MLP_CTor
                      ((["Prims"], "Cons"), [hd_pat; tail_pat])
                     in
                  let fst_pat v =
                    FStar_Extraction_ML_Syntax.MLP_Tuple
                      [FStar_Extraction_ML_Syntax.MLP_Var v;
                      FStar_Extraction_ML_Syntax.MLP_Wild]
                     in
                  let pattern =
                    FStar_List.fold_right
                      (fun hd_var  -> mk_cons (fst_pat hd_var)) tvar_names
                      args_tail
                     in
                  let branch =
                    let uu____4643 =
                      let uu____4644 =
                        let uu____4645 =
                          let uu____4652 =
                            let uu____4655 = as_name ([], "args")  in
                            [uu____4655]  in
                          (body, uu____4652)  in
                        FStar_Extraction_ML_Syntax.MLE_App uu____4645  in
                      FStar_All.pipe_left w uu____4644  in
                    (pattern, FStar_Pervasives_Native.None, uu____4643)  in
                  let default_branch =
                    let uu____4675 =
                      let uu____4676 =
                        let uu____4677 =
                          let uu____4684 = str_to_name "failwith"  in
                          let uu____4686 =
                            let uu____4689 =
                              let uu____4690 =
                                mlexpr_of_const FStar_Range.dummyRange
                                  (FStar_Const.Const_string
                                     ("arity mismatch",
                                       FStar_Range.dummyRange))
                                 in
                              FStar_All.pipe_left w uu____4690  in
                            [uu____4689]  in
                          (uu____4684, uu____4686)  in
                        FStar_Extraction_ML_Syntax.MLE_App uu____4677  in
                      FStar_All.pipe_left w uu____4676  in
                    (FStar_Extraction_ML_Syntax.MLP_Wild,
                      FStar_Pervasives_Native.None, uu____4675)
                     in
                  let body1 =
                    let uu____4698 =
                      let uu____4699 =
                        let uu____4714 = as_name ([], "args")  in
                        (uu____4714, [branch; default_branch])  in
                      FStar_Extraction_ML_Syntax.MLE_Match uu____4699  in
                    FStar_All.pipe_left w uu____4698  in
                  let body2 =
                    let uu____4756 =
                      let uu____4757 =
                        let uu____4764 =
                          as_name (["FStar_Syntax_Embeddings"], "debug_wrap")
                           in
                        let uu____4773 =
                          let uu____4776 =
                            let uu____4777 =
                              let uu____4778 =
                                let uu____4779 =
                                  FStar_Ident.string_of_lid fv_lid  in
                                FStar_Extraction_ML_Syntax.MLC_String
                                  uu____4779
                                 in
                              FStar_Extraction_ML_Syntax.MLE_Const uu____4778
                               in
                            FStar_All.pipe_left
                              (FStar_Extraction_ML_Syntax.with_ty
                                 FStar_Extraction_ML_Syntax.MLTY_Top)
                              uu____4777
                             in
                          let uu____4781 =
                            let uu____4784 = mk_lam "_" body1  in
                            [uu____4784]  in
                          uu____4776 :: uu____4781  in
                        (uu____4764, uu____4773)  in
                      FStar_Extraction_ML_Syntax.MLE_App uu____4757  in
                    FStar_All.pipe_left w uu____4756  in
                  mk_lam "args" body2
               in
            let uu____4789 = FStar_Syntax_Util.arrow_formals_comp t1  in
            match uu____4789 with
            | (bs,c) ->
                let uu____4798 =
                  match arity_opt with
                  | FStar_Pervasives_Native.None  -> (bs, c)
                  | FStar_Pervasives_Native.Some n ->
                      let n_bs = FStar_List.length bs  in
                      if n = n_bs
                      then (bs, c)
                      else
                        if n < n_bs
                        then
                          (let uu____4891 = FStar_Util.first_N n bs  in
                           match uu____4891 with
                           | (bs1,rest) ->
                               let c1 =
                                 let uu____4969 =
                                   FStar_Syntax_Util.arrow rest c  in
                                 FStar_All.pipe_left
                                   FStar_Syntax_Syntax.mk_Total uu____4969
                                  in
                               (bs1, c1))
                        else
                          (let msg =
                             let uu____4986 =
                               FStar_Ident.string_of_lid fv_lid  in
                             let uu____4988 = FStar_Util.string_of_int n  in
                             let uu____4990 = FStar_Util.string_of_int n_bs
                                in
                             FStar_Util.format3
                               "Embedding not defined for %s; expected arity at least %s; got %s"
                               uu____4986 uu____4988 uu____4990
                              in
                           FStar_Exn.raise (NoTacticEmbedding msg))
                   in
                (match uu____4798 with
                 | (bs1,c1) ->
                     let result_typ = FStar_Syntax_Util.comp_result c1  in
                     let arity = FStar_List.length bs1  in
                     let uu____5041 =
                       let uu____5062 =
                         FStar_Util.prefix_until
                           (fun uu____5104  ->
                              match uu____5104 with
                              | (b,uu____5113) ->
                                  let uu____5118 =
                                    let uu____5119 =
                                      FStar_Syntax_Subst.compress
                                        b.FStar_Syntax_Syntax.sort
                                       in
                                    uu____5119.FStar_Syntax_Syntax.n  in
                                  (match uu____5118 with
                                   | FStar_Syntax_Syntax.Tm_type uu____5123
                                       -> false
                                   | uu____5125 -> true)) bs1
                          in
                       match uu____5062 with
                       | FStar_Pervasives_Native.None  -> (bs1, [])
                       | FStar_Pervasives_Native.Some (tvars,x,rest) ->
                           (tvars, (x :: rest))
                        in
                     (match uu____5041 with
                      | (type_vars,bs2) ->
                          let tvar_arity = FStar_List.length type_vars  in
                          let non_tvar_arity = FStar_List.length bs2  in
                          let tvar_names =
                            FStar_List.mapi
                              (fun i  ->
                                 fun tv  ->
                                   let uu____5367 =
                                     FStar_Util.string_of_int i  in
                                   Prims.op_Hat "tv_" uu____5367) type_vars
                             in
                          let tvar_context =
                            FStar_List.map2
                              (fun b  ->
                                 fun nm  ->
                                   ((FStar_Pervasives_Native.fst b), nm))
                              type_vars tvar_names
                             in
                          let rec aux loc accum_embeddings bs3 =
                            match bs3 with
                            | [] ->
                                let arg_unembeddings =
                                  FStar_List.rev accum_embeddings  in
                                let res_embedding =
                                  mk_embedding loc tvar_context result_typ
                                   in
                                let fv_lid1 =
                                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                   in
                                let uu____5467 =
                                  FStar_Syntax_Util.is_pure_comp c1  in
                                if uu____5467
                                then
                                  let cb = str_to_name "cb"  in
                                  let embed_fun_N =
                                    mk_arrow_as_prim_step loc non_tvar_arity
                                     in
                                  let args =
                                    let uu____5484 =
                                      let uu____5487 =
                                        let uu____5490 = lid_to_name fv_lid1
                                           in
                                        let uu____5491 =
                                          let uu____5494 =
                                            let uu____5495 =
                                              let uu____5496 =
                                                let uu____5497 =
                                                  let uu____5509 =
                                                    FStar_Util.string_of_int
                                                      tvar_arity
                                                     in
                                                  (uu____5509,
                                                    FStar_Pervasives_Native.None)
                                                   in
                                                FStar_Extraction_ML_Syntax.MLC_Int
                                                  uu____5497
                                                 in
                                              FStar_Extraction_ML_Syntax.MLE_Const
                                                uu____5496
                                               in
                                            FStar_All.pipe_left
                                              (FStar_Extraction_ML_Syntax.with_ty
                                                 FStar_Extraction_ML_Syntax.MLTY_Top)
                                              uu____5495
                                             in
                                          [uu____5494; fv_lid_embedded; cb]
                                           in
                                        uu____5490 :: uu____5491  in
                                      res_embedding :: uu____5487  in
                                    FStar_List.append arg_unembeddings
                                      uu____5484
                                     in
                                  let fun_embedding =
                                    FStar_All.pipe_left w
                                      (FStar_Extraction_ML_Syntax.MLE_App
                                         (embed_fun_N, args))
                                     in
                                  let tabs =
                                    abstract_tvars tvar_names fun_embedding
                                     in
                                  let cb_tabs = mk_lam "cb" tabs  in
                                  let uu____5528 =
                                    if loc = NBE_t
                                    then cb_tabs
                                    else mk_lam "_psc" cb_tabs  in
                                  (uu____5528, arity, true)
                                else
                                  (let uu____5538 =
                                     let uu____5540 =
                                       FStar_TypeChecker_Env.norm_eff_name
                                         tcenv
                                         (FStar_Syntax_Util.comp_effect_name
                                            c1)
                                        in
                                     FStar_Ident.lid_equals uu____5540
                                       FStar_Parser_Const.effect_TAC_lid
                                      in
                                   if uu____5538
                                   then
                                     let h =
                                       mk_tactic_interpretation loc
                                         non_tvar_arity
                                        in
                                     let tac_fun =
                                       let uu____5552 =
                                         let uu____5553 =
                                           let uu____5560 =
                                             mk_from_tactic loc
                                               non_tvar_arity
                                              in
                                           let uu____5561 =
                                             let uu____5564 =
                                               lid_to_name fv_lid1  in
                                             [uu____5564]  in
                                           (uu____5560, uu____5561)  in
                                         FStar_Extraction_ML_Syntax.MLE_App
                                           uu____5553
                                          in
                                       FStar_All.pipe_left w uu____5552  in
                                     let psc = str_to_name "psc"  in
                                     let ncb = str_to_name "ncb"  in
                                     let all_args = str_to_name "args"  in
                                     let args =
                                       FStar_List.append [tac_fun]
                                         (FStar_List.append arg_unembeddings
                                            [res_embedding; psc; ncb])
                                        in
                                     let tabs =
                                       match tvar_names with
                                       | [] ->
                                           let uu____5578 =
                                             FStar_All.pipe_left w
                                               (FStar_Extraction_ML_Syntax.MLE_App
                                                  (h,
                                                    (FStar_List.append args
                                                       [all_args])))
                                              in
                                           mk_lam "args" uu____5578
                                       | uu____5582 ->
                                           let uu____5586 =
                                             FStar_All.pipe_left w
                                               (FStar_Extraction_ML_Syntax.MLE_App
                                                  (h, args))
                                              in
                                           abstract_tvars tvar_names
                                             uu____5586
                                        in
                                     let uu____5589 =
                                       let uu____5590 = mk_lam "ncb" tabs  in
                                       mk_lam "psc" uu____5590  in
                                     (uu____5589, (arity + Prims.int_one),
                                       false)
                                   else
                                     (let uu____5599 =
                                        let uu____5600 =
                                          let uu____5602 =
                                            FStar_Syntax_Print.term_to_string
                                              t1
                                             in
                                          Prims.op_Hat
                                            "Plugins not defined for type "
                                            uu____5602
                                           in
                                        NoTacticEmbedding uu____5600  in
                                      FStar_Exn.raise uu____5599))
                            | (b,uu____5614)::bs4 ->
                                let uu____5634 =
                                  let uu____5637 =
                                    mk_embedding loc tvar_context
                                      b.FStar_Syntax_Syntax.sort
                                     in
                                  uu____5637 :: accum_embeddings  in
                                aux loc uu____5634 bs4
                             in
                          (try
                             (fun uu___710_5659  ->
                                match () with
                                | () ->
                                    let uu____5672 = aux Syntax_term [] bs2
                                       in
                                    (match uu____5672 with
                                     | (w1,a,b) ->
                                         let uu____5700 = aux NBE_t [] bs2
                                            in
                                         (match uu____5700 with
                                          | (w',uu____5722,uu____5723) ->
                                              FStar_Pervasives_Native.Some
                                                (w1, w', a, b)))) ()
                           with
                           | NoTacticEmbedding msg ->
                               ((let uu____5759 =
                                   FStar_Syntax_Print.fv_to_string fv  in
                                 not_implemented_warning
                                   t1.FStar_Syntax_Syntax.pos uu____5759 msg);
                                FStar_Pervasives_Native.None))))
  