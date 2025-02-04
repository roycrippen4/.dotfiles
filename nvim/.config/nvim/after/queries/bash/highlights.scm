; extends

(command
 argument: (word) @bash.path
 (#match? @bash.path "^/"))

(command
  name: (command_name
    (word))
  argument: (word) @bash.flag.single
  (#match? @bash.flag.single "^-[^-]"))

(command
  name: (command_name
    (word))
  argument: (word) @bash.flag.double
  (#match? @bash.flag.double "^--"))

((comment) @kitty.color
  (#match? @kitty.color "#[0-9a-fA-F]{3,6}"))
