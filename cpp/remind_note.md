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
- A declaration of element should be seen by C linker should be in `extern "C" {}`. 
    ```
    #ifdef __cplusplus
    extern "C"
    {
    #endif

    ... CPP CODE FOR C LINKER

    #ifdef __cplusplus
    }
    #endif
    ```
    - Import C header in `extern "C" {}` block to use in C++.
- One could use `throw` to fail object construction.
- Do not specialize template struct inside of another struct. See [this](https://stackoverflow.com/questions/57530656/template-member-specialization-in-template-class).
- It is good practice to use switch-case statements for template argument. unused paths will not be compiled.