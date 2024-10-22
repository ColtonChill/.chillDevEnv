;; extends

;; Match variables like: int badname = 0;
(init_declarator
  declarator: (identifier) @spell)

;; Match parameters like: void func(std::string badname)
(parameter_declaration
  declarator: (identifier) @spell)

;; Match class
(class_specifier
  name: (type_identifier) @spell)

;; Spell check strings
(string_literal 
  (string_content) @spell) 
