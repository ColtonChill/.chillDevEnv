;; extends

;; Match variables like: int badname = 0;
(init_declarator
  declarator: (identifier) @spell)

;; Match parameters like: void func(std::string badname)
(parameter_declaration
  declarator: (identifier) @spell)

(class_specifier
  name: (type_identifier) @spell)

