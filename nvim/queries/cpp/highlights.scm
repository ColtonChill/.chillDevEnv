;; extends

;; If you see spell check
;; :InspectTree

;; Spell check strings
(string_literal 
  (string_content) @spell) 
;; Match variables like: int badname = 0;
(init_declarator
  declarator: (identifier) @spell)
;; Match parameters like: void func(std::string badname)
(parameter_declaration
  declarator: (identifier) @spell)

;; Match class
(class_specifier
  name: (type_identifier) @spell)
;; Match class member variable
(field_declaration 
  declarator: (field_identifier) @spell)
;; Match class members methods and parameters
(field_declaration
  declarator: (function_declarator
    declarator: (field_identifier) @spell
    parameters: (parameter_list
      (parameter_declaration 
        type: (primitive_type)
        declarator: (identifier) @spell))))
