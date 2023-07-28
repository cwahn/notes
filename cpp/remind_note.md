# CPP Remind Note

## Inheritance
- One can delete the method of the parent class.
- An inherited class could be up casted to the parent class. Therefore could be passed to functions taking arguments of parent class type.

## Miscellaneous 
- Template structure having type should be used with `typename` keyword unless aliased by `using`.
- If any variable is declared in the switch case, the case block should be covered with braces to form a block.
Static data members should be defined outside of the class or struct definition.
Consider that can't pass templates as arguments. They as to be concrete.
- A string constant should have the type of `const char *`, not `char *`, even with `constexpr`.
Some libraries hide async action behind. It could occur some weird output. 