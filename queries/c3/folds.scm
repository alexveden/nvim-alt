;(func_definition) @fold    ; fold full fn
;(macro_declaration)  @fold ; fold full macro

(func_definition (macro_func_body) @fold)  ; folds only {}, if on new line!
(macro_declaration (macro_func_body)  @fold) ; folds only {}, if on new line!

(switch_body ((case_stmt) @fold))
(enum_body) @fold
;(doc_comment_text)  @fold
((doc_comment)  @fold (#set! "fold.level" 1))
