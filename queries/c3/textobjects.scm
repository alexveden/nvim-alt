;;extends
; My special queries c3

(source_file
 (func_definition) @function.outer)

(source_file
 (macro_declaration) @function.outer)

(source_file
 (define_declaration) @type.declaration)

(source_file
 (struct_declaration) @type.declaration)

(source_file
 (distinct_declaration) @type.declaration)

(source_file
 (bitstruct_declaration) @type.declaration)

(source_file
 (enum_declaration) @type.declaration)

(source_file
 (interface_declaration) @type.declaration)

(source_file
 (fault_declaration) @type.declaration)

