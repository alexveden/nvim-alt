;;extends
; markdown highlighting inside Jupytext notebook
((
  (comment) @_mdcomment
  . (expression_statement 
      (string (string_content) @injection.content)))
  (#set! injection.language "markdown")
  (#lua-match? @_mdcomment "^# %%%% %[markdown%]"))
