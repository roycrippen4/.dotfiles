;; extends

((nested_type_identifier) @type.type_argument
  (#has-ancestor? @type.type_argument type_arguments))

((predefined_type) @type.type_argument
  (#has-ancestor? @type.type_argument type_arguments))

((type_identifier) @type.type_argument
  (#has-ancestor? @type.type_argument type_arguments))

((literal_type) @type.type_argument
 (#has-ancestor? @type.type_argument type_arguments))

