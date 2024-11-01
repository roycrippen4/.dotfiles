; extends


((identifier) @boolean.zig
 (#match? @boolean.zig "^(true|false)$"))

((identifier) @variable.std
  (#match? @variable.std "^std$"))

(test_declaration 
  (string 
    (string_content) @test))

(call_expression
  function: 
  (error_union_type
    ok: (identifier) @fix_error_union_type))
