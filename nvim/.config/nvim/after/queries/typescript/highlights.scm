;; extends

(type_arguments
  (tuple_type
    (type_identifier) @type.type_argument))

(type_arguments
  (tuple_type
    (predefined_type) @type.type_argument))

(type_arguments
  (predefined_type) @type.type_argument)

(type_arguments
  (type_identifier) @type.type_argument)

(type_arguments
  (union_type (literal_type _) @type.type_argument))

(type_arguments
  (union_type
    (type_identifier) @type.type_argument))
