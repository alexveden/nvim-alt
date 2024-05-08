;;extends
; My special queries for jupytext notebooks

(module
 (comment) @code_cell.comment
 (#lua-match? @code_cell.comment "^# %%%%%s*$"))

(module
 (comment) @cell.comment
 (#lua-match? @cell.comment "^# %%%%"))
