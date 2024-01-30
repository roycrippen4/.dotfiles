;; extends

(generic_type 
  type_arguments: (type_arguments 
    (type_identifier) @type.argument)) 

(type_arguments
            (predefined_type) @type.argument) 

(variable_declarator
  (array_pattern
    (identifier) @variable.useState
    (identifier) @function.useState)
  (call_expression
    function: (identifier) @function.builtin.useState))
