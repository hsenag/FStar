open Prims
let unembed :
  'uuuuuu8 .
    'uuuuuu8 FStar_Syntax_Embeddings.embedding ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Embeddings.norm_cb ->
          'uuuuuu8 FStar_Pervasives_Native.option
  =
  fun ea  ->
    fun a  ->
      fun norm_cb  ->
        let uu____32 = FStar_Syntax_Embeddings.unembed ea a  in
        uu____32 true norm_cb
  
let try_unembed :
  'uuuuuu49 .
    'uuuuuu49 FStar_Syntax_Embeddings.embedding ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Embeddings.norm_cb ->
          'uuuuuu49 FStar_Pervasives_Native.option
  =
  fun ea  ->
    fun a  ->
      fun norm_cb  ->
        let uu____73 = FStar_Syntax_Embeddings.unembed ea a  in
        uu____73 false norm_cb
  
let embed :
  'uuuuuu92 .
    'uuuuuu92 FStar_Syntax_Embeddings.embedding ->
      FStar_Range.range ->
        'uuuuuu92 ->
          FStar_Syntax_Embeddings.norm_cb -> FStar_Syntax_Syntax.term
  =
  fun ea  ->
    fun r  ->
      fun x  ->
        fun norm_cb  ->
          let uu____119 = FStar_Syntax_Embeddings.embed ea x  in
          uu____119 r FStar_Pervasives_Native.None norm_cb
  
let int1 :
  'a 'r .
    FStar_Ident.lid ->
      ('a -> 'r) ->
        'a FStar_Syntax_Embeddings.embedding ->
          'r FStar_Syntax_Embeddings.embedding ->
            FStar_TypeChecker_Cfg.psc ->
              FStar_Syntax_Embeddings.norm_cb ->
                FStar_Syntax_Syntax.args ->
                  FStar_Syntax_Syntax.term FStar_Pervasives_Native.option
  =
  fun m  ->
    fun f  ->
      fun ea  ->
        fun er  ->
          fun psc  ->
            fun n  ->
              fun args  ->
                match args with
                | (a1,uu____202)::[] ->
                    let uu____227 = try_unembed ea a1 n  in
                    FStar_Util.bind_opt uu____227
                      (fun a2  ->
                         let uu____233 =
                           let uu____234 =
                             FStar_TypeChecker_Cfg.psc_range psc  in
                           let uu____235 = f a2  in
                           embed er uu____234 uu____235 n  in
                         FStar_Pervasives_Native.Some uu____233)
                | uu____236 -> FStar_Pervasives_Native.None
  
let int2 :
  'a 'b 'r .
    FStar_Ident.lid ->
      ('a -> 'b -> 'r) ->
        'a FStar_Syntax_Embeddings.embedding ->
          'b FStar_Syntax_Embeddings.embedding ->
            'r FStar_Syntax_Embeddings.embedding ->
              FStar_TypeChecker_Cfg.psc ->
                FStar_Syntax_Embeddings.norm_cb ->
                  FStar_Syntax_Syntax.args ->
                    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option
  =
  fun m  ->
    fun f  ->
      fun ea  ->
        fun eb  ->
          fun er  ->
            fun psc  ->
              fun n  ->
                fun args  ->
                  match args with
                  | (a1,uu____330)::(b1,uu____332)::[] ->
                      let uu____373 = try_unembed ea a1 n  in
                      FStar_Util.bind_opt uu____373
                        (fun a2  ->
                           let uu____379 = try_unembed eb b1 n  in
                           FStar_Util.bind_opt uu____379
                             (fun b2  ->
                                let uu____385 =
                                  let uu____386 =
                                    FStar_TypeChecker_Cfg.psc_range psc  in
                                  let uu____387 = f a2 b2  in
                                  embed er uu____386 uu____387 n  in
                                FStar_Pervasives_Native.Some uu____385))
                  | uu____388 -> FStar_Pervasives_Native.None
  
let nbe_int1 :
  'a 'r .
    FStar_Ident.lid ->
      ('a -> 'r) ->
        'a FStar_TypeChecker_NBETerm.embedding ->
          'r FStar_TypeChecker_NBETerm.embedding ->
            FStar_TypeChecker_NBETerm.nbe_cbs ->
              FStar_TypeChecker_NBETerm.args ->
                FStar_TypeChecker_NBETerm.t FStar_Pervasives_Native.option
  =
  fun m  ->
    fun f  ->
      fun ea  ->
        fun er  ->
          fun cb  ->
            fun args  ->
              match args with
              | (a1,uu____454)::[] ->
                  let uu____463 = FStar_TypeChecker_NBETerm.unembed ea cb a1
                     in
                  FStar_Util.bind_opt uu____463
                    (fun a2  ->
                       let uu____469 =
                         let uu____470 = f a2  in
                         FStar_TypeChecker_NBETerm.embed er cb uu____470  in
                       FStar_Pervasives_Native.Some uu____469)
              | uu____471 -> FStar_Pervasives_Native.None
  
let nbe_int2 :
  'a 'b 'r .
    FStar_Ident.lid ->
      ('a -> 'b -> 'r) ->
        'a FStar_TypeChecker_NBETerm.embedding ->
          'b FStar_TypeChecker_NBETerm.embedding ->
            'r FStar_TypeChecker_NBETerm.embedding ->
              FStar_TypeChecker_NBETerm.nbe_cbs ->
                FStar_TypeChecker_NBETerm.args ->
                  FStar_TypeChecker_NBETerm.t FStar_Pervasives_Native.option
  =
  fun m  ->
    fun f  ->
      fun ea  ->
        fun eb  ->
          fun er  ->
            fun cb  ->
              fun args  ->
                match args with
                | (a1,uu____556)::(b1,uu____558)::[] ->
                    let uu____571 =
                      FStar_TypeChecker_NBETerm.unembed ea cb a1  in
                    FStar_Util.bind_opt uu____571
                      (fun a2  ->
                         let uu____577 =
                           FStar_TypeChecker_NBETerm.unembed eb cb b1  in
                         FStar_Util.bind_opt uu____577
                           (fun b2  ->
                              let uu____583 =
                                let uu____584 = f a2 b2  in
                                FStar_TypeChecker_NBETerm.embed er cb
                                  uu____584
                                 in
                              FStar_Pervasives_Native.Some uu____583))
                | uu____585 -> FStar_Pervasives_Native.None
  
let (mklid : Prims.string -> FStar_Ident.lid) =
  fun nm  -> FStar_Reflection_Data.fstar_refl_builtins_lid nm 
let (mk :
  FStar_Ident.lid ->
    Prims.int ->
      (FStar_TypeChecker_Cfg.psc ->
         FStar_Syntax_Embeddings.norm_cb ->
           FStar_Syntax_Syntax.args ->
             FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
        ->
        (FStar_TypeChecker_NBETerm.nbe_cbs ->
           FStar_TypeChecker_NBETerm.args ->
             FStar_TypeChecker_NBETerm.t FStar_Pervasives_Native.option)
          -> FStar_TypeChecker_Cfg.primitive_step)
  =
  fun l  ->
    fun arity  ->
      fun fn  ->
        fun nbe_fn  ->
          {
            FStar_TypeChecker_Cfg.name = l;
            FStar_TypeChecker_Cfg.arity = arity;
            FStar_TypeChecker_Cfg.univ_arity = Prims.int_zero;
            FStar_TypeChecker_Cfg.auto_reflect = FStar_Pervasives_Native.None;
            FStar_TypeChecker_Cfg.strong_reduction_ok = true;
            FStar_TypeChecker_Cfg.requires_binder_substitution = false;
            FStar_TypeChecker_Cfg.interpretation = fn;
            FStar_TypeChecker_Cfg.interpretation_nbe = nbe_fn
          }
  
let mk1 :
  'a 'na 'nr 'r .
    Prims.string ->
      ('a -> 'r) ->
        'a FStar_Syntax_Embeddings.embedding ->
          'r FStar_Syntax_Embeddings.embedding ->
            ('na -> 'nr) ->
              'na FStar_TypeChecker_NBETerm.embedding ->
                'nr FStar_TypeChecker_NBETerm.embedding ->
                  FStar_TypeChecker_Cfg.primitive_step
  =
  fun nm  ->
    fun f  ->
      fun ea  ->
        fun er  ->
          fun nf  ->
            fun ena  ->
              fun enr  ->
                let l = mklid nm  in
                mk l Prims.int_one (int1 l f ea er) (nbe_int1 l nf ena enr)
  
let mk2 :
  'a 'b 'na 'nb 'nr 'r .
    Prims.string ->
      ('a -> 'b -> 'r) ->
        'a FStar_Syntax_Embeddings.embedding ->
          'b FStar_Syntax_Embeddings.embedding ->
            'r FStar_Syntax_Embeddings.embedding ->
              ('na -> 'nb -> 'nr) ->
                'na FStar_TypeChecker_NBETerm.embedding ->
                  'nb FStar_TypeChecker_NBETerm.embedding ->
                    'nr FStar_TypeChecker_NBETerm.embedding ->
                      FStar_TypeChecker_Cfg.primitive_step
  =
  fun nm  ->
    fun f  ->
      fun ea  ->
        fun eb  ->
          fun er  ->
            fun nf  ->
              fun ena  ->
                fun enb  ->
                  fun enr  ->
                    let l = mklid nm  in
                    mk l (Prims.of_int (2)) (int2 l f ea eb er)
                      (nbe_int2 l nf ena enb enr)
  
let (reflection_primops : FStar_TypeChecker_Cfg.primitive_step Prims.list) =
  let uu____883 =
    mk1 "inspect_ln" FStar_Reflection_Basic.inspect_ln
      FStar_Reflection_Embeddings.e_term
      FStar_Reflection_Embeddings.e_term_view
      FStar_Reflection_Basic.inspect_ln FStar_Reflection_NBEEmbeddings.e_term
      FStar_Reflection_NBEEmbeddings.e_term_view
     in
  let uu____885 =
    let uu____888 =
      mk1 "pack_ln" FStar_Reflection_Basic.pack_ln
        FStar_Reflection_Embeddings.e_term_view
        FStar_Reflection_Embeddings.e_term FStar_Reflection_Basic.pack_ln
        FStar_Reflection_NBEEmbeddings.e_term_view
        FStar_Reflection_NBEEmbeddings.e_term
       in
    let uu____890 =
      let uu____893 =
        mk1 "inspect_fv" FStar_Reflection_Basic.inspect_fv
          FStar_Reflection_Embeddings.e_fv
          FStar_Syntax_Embeddings.e_string_list
          FStar_Reflection_Basic.inspect_fv
          FStar_Reflection_NBEEmbeddings.e_fv
          FStar_TypeChecker_NBETerm.e_string_list
         in
      let uu____901 =
        let uu____904 =
          mk1 "pack_fv" FStar_Reflection_Basic.pack_fv
            FStar_Syntax_Embeddings.e_string_list
            FStar_Reflection_Embeddings.e_fv FStar_Reflection_Basic.pack_fv
            FStar_TypeChecker_NBETerm.e_string_list
            FStar_Reflection_NBEEmbeddings.e_fv
           in
        let uu____912 =
          let uu____915 =
            mk1 "inspect_comp" FStar_Reflection_Basic.inspect_comp
              FStar_Reflection_Embeddings.e_comp
              FStar_Reflection_Embeddings.e_comp_view
              FStar_Reflection_Basic.inspect_comp
              FStar_Reflection_NBEEmbeddings.e_comp
              FStar_Reflection_NBEEmbeddings.e_comp_view
             in
          let uu____917 =
            let uu____920 =
              mk1 "pack_comp" FStar_Reflection_Basic.pack_comp
                FStar_Reflection_Embeddings.e_comp_view
                FStar_Reflection_Embeddings.e_comp
                FStar_Reflection_Basic.pack_comp
                FStar_Reflection_NBEEmbeddings.e_comp_view
                FStar_Reflection_NBEEmbeddings.e_comp
               in
            let uu____922 =
              let uu____925 =
                mk1 "inspect_sigelt" FStar_Reflection_Basic.inspect_sigelt
                  FStar_Reflection_Embeddings.e_sigelt
                  FStar_Reflection_Embeddings.e_sigelt_view
                  FStar_Reflection_Basic.inspect_sigelt
                  FStar_Reflection_NBEEmbeddings.e_sigelt
                  FStar_Reflection_NBEEmbeddings.e_sigelt_view
                 in
              let uu____927 =
                let uu____930 =
                  mk1 "pack_sigelt" FStar_Reflection_Basic.pack_sigelt
                    FStar_Reflection_Embeddings.e_sigelt_view
                    FStar_Reflection_Embeddings.e_sigelt
                    FStar_Reflection_Basic.pack_sigelt
                    FStar_Reflection_NBEEmbeddings.e_sigelt_view
                    FStar_Reflection_NBEEmbeddings.e_sigelt
                   in
                let uu____932 =
                  let uu____935 =
                    mk1 "inspect_bv" FStar_Reflection_Basic.inspect_bv
                      FStar_Reflection_Embeddings.e_bv
                      FStar_Reflection_Embeddings.e_bv_view
                      FStar_Reflection_Basic.inspect_bv
                      FStar_Reflection_NBEEmbeddings.e_bv
                      FStar_Reflection_NBEEmbeddings.e_bv_view
                     in
                  let uu____937 =
                    let uu____940 =
                      mk1 "pack_bv" FStar_Reflection_Basic.pack_bv
                        FStar_Reflection_Embeddings.e_bv_view
                        FStar_Reflection_Embeddings.e_bv
                        FStar_Reflection_Basic.pack_bv
                        FStar_Reflection_NBEEmbeddings.e_bv_view
                        FStar_Reflection_NBEEmbeddings.e_bv
                       in
                    let uu____942 =
                      let uu____945 =
                        let uu____946 =
                          FStar_Syntax_Embeddings.e_option
                            FStar_Reflection_Embeddings.e_term
                           in
                        let uu____951 =
                          FStar_TypeChecker_NBETerm.e_option
                            FStar_Reflection_NBEEmbeddings.e_term
                           in
                        mk1 "sigelt_opts" FStar_Reflection_Basic.sigelt_opts
                          FStar_Reflection_Embeddings.e_sigelt uu____946
                          FStar_Reflection_Basic.sigelt_opts
                          FStar_Reflection_NBEEmbeddings.e_sigelt uu____951
                         in
                      let uu____961 =
                        let uu____964 =
                          mk1 "sigelt_attrs"
                            FStar_Reflection_Basic.sigelt_attrs
                            FStar_Reflection_Embeddings.e_sigelt
                            FStar_Reflection_Embeddings.e_attributes
                            FStar_Reflection_Basic.sigelt_attrs
                            FStar_Reflection_NBEEmbeddings.e_sigelt
                            FStar_Reflection_NBEEmbeddings.e_attributes
                           in
                        let uu____970 =
                          let uu____973 =
                            mk2 "set_sigelt_attrs"
                              FStar_Reflection_Basic.set_sigelt_attrs
                              FStar_Reflection_Embeddings.e_attributes
                              FStar_Reflection_Embeddings.e_sigelt
                              FStar_Reflection_Embeddings.e_sigelt
                              FStar_Reflection_Basic.set_sigelt_attrs
                              FStar_Reflection_NBEEmbeddings.e_attributes
                              FStar_Reflection_NBEEmbeddings.e_sigelt
                              FStar_Reflection_NBEEmbeddings.e_sigelt
                             in
                          let uu____979 =
                            let uu____982 =
                              mk1 "sigelt_quals"
                                FStar_Reflection_Basic.sigelt_quals
                                FStar_Reflection_Embeddings.e_sigelt
                                FStar_Reflection_Embeddings.e_qualifiers
                                FStar_Reflection_Basic.sigelt_quals
                                FStar_Reflection_NBEEmbeddings.e_sigelt
                                FStar_Reflection_NBEEmbeddings.e_qualifiers
                               in
                            let uu____988 =
                              let uu____991 =
                                mk2 "set_sigelt_quals"
                                  FStar_Reflection_Basic.set_sigelt_quals
                                  FStar_Reflection_Embeddings.e_qualifiers
                                  FStar_Reflection_Embeddings.e_sigelt
                                  FStar_Reflection_Embeddings.e_sigelt
                                  FStar_Reflection_Basic.set_sigelt_quals
                                  FStar_Reflection_NBEEmbeddings.e_qualifiers
                                  FStar_Reflection_NBEEmbeddings.e_sigelt
                                  FStar_Reflection_NBEEmbeddings.e_sigelt
                                 in
                              let uu____997 =
                                let uu____1000 =
                                  mk1 "inspect_binder"
                                    FStar_Reflection_Basic.inspect_binder
                                    FStar_Reflection_Embeddings.e_binder
                                    FStar_Reflection_Embeddings.e_binder_view
                                    FStar_Reflection_Basic.inspect_binder
                                    FStar_Reflection_NBEEmbeddings.e_binder
                                    FStar_Reflection_NBEEmbeddings.e_binder_view
                                   in
                                let uu____1002 =
                                  let uu____1005 =
                                    mk2 "pack_binder"
                                      FStar_Reflection_Basic.pack_binder
                                      FStar_Reflection_Embeddings.e_bv
                                      FStar_Reflection_Embeddings.e_aqualv
                                      FStar_Reflection_Embeddings.e_binder
                                      FStar_Reflection_Basic.pack_binder
                                      FStar_Reflection_NBEEmbeddings.e_bv
                                      FStar_Reflection_NBEEmbeddings.e_aqualv
                                      FStar_Reflection_NBEEmbeddings.e_binder
                                     in
                                  let uu____1007 =
                                    let uu____1010 =
                                      mk2 "compare_bv"
                                        FStar_Reflection_Basic.compare_bv
                                        FStar_Reflection_Embeddings.e_bv
                                        FStar_Reflection_Embeddings.e_bv
                                        FStar_Reflection_Embeddings.e_order
                                        FStar_Reflection_Basic.compare_bv
                                        FStar_Reflection_NBEEmbeddings.e_bv
                                        FStar_Reflection_NBEEmbeddings.e_bv
                                        FStar_Reflection_NBEEmbeddings.e_order
                                       in
                                    let uu____1012 =
                                      let uu____1015 =
                                        mk2 "is_free"
                                          FStar_Reflection_Basic.is_free
                                          FStar_Reflection_Embeddings.e_bv
                                          FStar_Reflection_Embeddings.e_term
                                          FStar_Syntax_Embeddings.e_bool
                                          FStar_Reflection_Basic.is_free
                                          FStar_Reflection_NBEEmbeddings.e_bv
                                          FStar_Reflection_NBEEmbeddings.e_term
                                          FStar_TypeChecker_NBETerm.e_bool
                                         in
                                      let uu____1019 =
                                        let uu____1022 =
                                          let uu____1023 =
                                            FStar_Syntax_Embeddings.e_list
                                              FStar_Reflection_Embeddings.e_fv
                                             in
                                          let uu____1028 =
                                            FStar_TypeChecker_NBETerm.e_list
                                              FStar_Reflection_NBEEmbeddings.e_fv
                                             in
                                          mk2 "lookup_attr"
                                            FStar_Reflection_Basic.lookup_attr
                                            FStar_Reflection_Embeddings.e_term
                                            FStar_Reflection_Embeddings.e_env
                                            uu____1023
                                            FStar_Reflection_Basic.lookup_attr
                                            FStar_Reflection_NBEEmbeddings.e_term
                                            FStar_Reflection_NBEEmbeddings.e_env
                                            uu____1028
                                           in
                                        let uu____1038 =
                                          let uu____1041 =
                                            let uu____1042 =
                                              FStar_Syntax_Embeddings.e_list
                                                FStar_Reflection_Embeddings.e_fv
                                               in
                                            let uu____1047 =
                                              FStar_TypeChecker_NBETerm.e_list
                                                FStar_Reflection_NBEEmbeddings.e_fv
                                               in
                                            mk1 "all_defs_in_env"
                                              FStar_Reflection_Basic.all_defs_in_env
                                              FStar_Reflection_Embeddings.e_env
                                              uu____1042
                                              FStar_Reflection_Basic.all_defs_in_env
                                              FStar_Reflection_NBEEmbeddings.e_env
                                              uu____1047
                                             in
                                          let uu____1057 =
                                            let uu____1060 =
                                              let uu____1061 =
                                                FStar_Syntax_Embeddings.e_list
                                                  FStar_Reflection_Embeddings.e_fv
                                                 in
                                              let uu____1066 =
                                                FStar_TypeChecker_NBETerm.e_list
                                                  FStar_Reflection_NBEEmbeddings.e_fv
                                                 in
                                              mk2 "defs_in_module"
                                                FStar_Reflection_Basic.defs_in_module
                                                FStar_Reflection_Embeddings.e_env
                                                FStar_Syntax_Embeddings.e_string_list
                                                uu____1061
                                                FStar_Reflection_Basic.defs_in_module
                                                FStar_Reflection_NBEEmbeddings.e_env
                                                FStar_TypeChecker_NBETerm.e_string_list
                                                uu____1066
                                               in
                                            let uu____1082 =
                                              let uu____1085 =
                                                mk2 "term_eq"
                                                  FStar_Reflection_Basic.term_eq
                                                  FStar_Reflection_Embeddings.e_term
                                                  FStar_Reflection_Embeddings.e_term
                                                  FStar_Syntax_Embeddings.e_bool
                                                  FStar_Reflection_Basic.term_eq
                                                  FStar_Reflection_NBEEmbeddings.e_term
                                                  FStar_Reflection_NBEEmbeddings.e_term
                                                  FStar_TypeChecker_NBETerm.e_bool
                                                 in
                                              let uu____1089 =
                                                let uu____1092 =
                                                  mk1 "moduleof"
                                                    FStar_Reflection_Basic.moduleof
                                                    FStar_Reflection_Embeddings.e_env
                                                    FStar_Syntax_Embeddings.e_string_list
                                                    FStar_Reflection_Basic.moduleof
                                                    FStar_Reflection_NBEEmbeddings.e_env
                                                    FStar_TypeChecker_NBETerm.e_string_list
                                                   in
                                                let uu____1100 =
                                                  let uu____1103 =
                                                    mk1 "term_to_string"
                                                      FStar_Reflection_Basic.term_to_string
                                                      FStar_Reflection_Embeddings.e_term
                                                      FStar_Syntax_Embeddings.e_string
                                                      FStar_Reflection_Basic.term_to_string
                                                      FStar_Reflection_NBEEmbeddings.e_term
                                                      FStar_TypeChecker_NBETerm.e_string
                                                     in
                                                  let uu____1107 =
                                                    let uu____1110 =
                                                      mk1 "comp_to_string"
                                                        FStar_Reflection_Basic.comp_to_string
                                                        FStar_Reflection_Embeddings.e_comp
                                                        FStar_Syntax_Embeddings.e_string
                                                        FStar_Reflection_Basic.comp_to_string
                                                        FStar_Reflection_NBEEmbeddings.e_comp
                                                        FStar_TypeChecker_NBETerm.e_string
                                                       in
                                                    let uu____1114 =
                                                      let uu____1117 =
                                                        mk1 "binders_of_env"
                                                          FStar_Reflection_Basic.binders_of_env
                                                          FStar_Reflection_Embeddings.e_env
                                                          FStar_Reflection_Embeddings.e_binders
                                                          FStar_Reflection_Basic.binders_of_env
                                                          FStar_Reflection_NBEEmbeddings.e_env
                                                          FStar_Reflection_NBEEmbeddings.e_binders
                                                         in
                                                      let uu____1119 =
                                                        let uu____1122 =
                                                          let uu____1123 =
                                                            FStar_Syntax_Embeddings.e_option
                                                              FStar_Reflection_Embeddings.e_sigelt
                                                             in
                                                          let uu____1128 =
                                                            FStar_TypeChecker_NBETerm.e_option
                                                              FStar_Reflection_NBEEmbeddings.e_sigelt
                                                             in
                                                          mk2 "lookup_typ"
                                                            FStar_Reflection_Basic.lookup_typ
                                                            FStar_Reflection_Embeddings.e_env
                                                            FStar_Syntax_Embeddings.e_string_list
                                                            uu____1123
                                                            FStar_Reflection_Basic.lookup_typ
                                                            FStar_Reflection_NBEEmbeddings.e_env
                                                            FStar_TypeChecker_NBETerm.e_string_list
                                                            uu____1128
                                                           in
                                                        let uu____1144 =
                                                          let uu____1147 =
                                                            let uu____1148 =
                                                              FStar_Syntax_Embeddings.e_list
                                                                FStar_Syntax_Embeddings.e_string_list
                                                               in
                                                            let uu____1159 =
                                                              FStar_TypeChecker_NBETerm.e_list
                                                                FStar_TypeChecker_NBETerm.e_string_list
                                                               in
                                                            mk1
                                                              "env_open_modules"
                                                              FStar_Reflection_Basic.env_open_modules
                                                              FStar_Reflection_Embeddings.e_env
                                                              uu____1148
                                                              FStar_Reflection_Basic.env_open_modules
                                                              FStar_Reflection_NBEEmbeddings.e_env
                                                              uu____1159
                                                             in
                                                          let uu____1181 =
                                                            let uu____1184 =
                                                              mk1
                                                                "implode_qn"
                                                                FStar_Reflection_Basic.implode_qn
                                                                FStar_Syntax_Embeddings.e_string_list
                                                                FStar_Syntax_Embeddings.e_string
                                                                FStar_Reflection_Basic.implode_qn
                                                                FStar_TypeChecker_NBETerm.e_string_list
                                                                FStar_TypeChecker_NBETerm.e_string
                                                               in
                                                            let uu____1194 =
                                                              let uu____1197
                                                                =
                                                                mk1
                                                                  "explode_qn"
                                                                  FStar_Reflection_Basic.explode_qn
                                                                  FStar_Syntax_Embeddings.e_string
                                                                  FStar_Syntax_Embeddings.e_string_list
                                                                  FStar_Reflection_Basic.explode_qn
                                                                  FStar_TypeChecker_NBETerm.e_string
                                                                  FStar_TypeChecker_NBETerm.e_string_list
                                                                 in
                                                              let uu____1207
                                                                =
                                                                let uu____1210
                                                                  =
                                                                  mk2
                                                                    "compare_string"
                                                                    FStar_Reflection_Basic.compare_string
                                                                    FStar_Syntax_Embeddings.e_string
                                                                    FStar_Syntax_Embeddings.e_string
                                                                    FStar_Syntax_Embeddings.e_int
                                                                    FStar_Reflection_Basic.compare_string
                                                                    FStar_TypeChecker_NBETerm.e_string
                                                                    FStar_TypeChecker_NBETerm.e_string
                                                                    FStar_TypeChecker_NBETerm.e_int
                                                                   in
                                                                let uu____1216
                                                                  =
                                                                  let uu____1219
                                                                    =
                                                                    mk2
                                                                    "push_binder"
                                                                    FStar_Reflection_Basic.push_binder
                                                                    FStar_Reflection_Embeddings.e_env
                                                                    FStar_Reflection_Embeddings.e_binder
                                                                    FStar_Reflection_Embeddings.e_env
                                                                    FStar_Reflection_Basic.push_binder
                                                                    FStar_Reflection_NBEEmbeddings.e_env
                                                                    FStar_Reflection_NBEEmbeddings.e_binder
                                                                    FStar_Reflection_NBEEmbeddings.e_env
                                                                     in
                                                                  [uu____1219]
                                                                   in
                                                                uu____1210 ::
                                                                  uu____1216
                                                                 in
                                                              uu____1197 ::
                                                                uu____1207
                                                               in
                                                            uu____1184 ::
                                                              uu____1194
                                                             in
                                                          uu____1147 ::
                                                            uu____1181
                                                           in
                                                        uu____1122 ::
                                                          uu____1144
                                                         in
                                                      uu____1117 ::
                                                        uu____1119
                                                       in
                                                    uu____1110 :: uu____1114
                                                     in
                                                  uu____1103 :: uu____1107
                                                   in
                                                uu____1092 :: uu____1100  in
                                              uu____1085 :: uu____1089  in
                                            uu____1060 :: uu____1082  in
                                          uu____1041 :: uu____1057  in
                                        uu____1022 :: uu____1038  in
                                      uu____1015 :: uu____1019  in
                                    uu____1010 :: uu____1012  in
                                  uu____1005 :: uu____1007  in
                                uu____1000 :: uu____1002  in
                              uu____991 :: uu____997  in
                            uu____982 :: uu____988  in
                          uu____973 :: uu____979  in
                        uu____964 :: uu____970  in
                      uu____945 :: uu____961  in
                    uu____940 :: uu____942  in
                  uu____935 :: uu____937  in
                uu____930 :: uu____932  in
              uu____925 :: uu____927  in
            uu____920 :: uu____922  in
          uu____915 :: uu____917  in
        uu____904 :: uu____912  in
      uu____893 :: uu____901  in
    uu____888 :: uu____890  in
  uu____883 :: uu____885 
let (uu___113 : unit) =
  FStar_List.iter FStar_TypeChecker_Cfg.register_extra_step
    reflection_primops
  