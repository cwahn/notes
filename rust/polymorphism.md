# Polymorphism
- [Polymorphism](#polymorphism)
  - [Keyword `dyn`](#keyword-dyn)
    - [Trait Object](#trait-object)
  - [Keyword `impl`](#keyword-impl)
    - [Syntactic Sugar for Anonymous Generic](#syntactic-sugar-for-anonymous-generic)
  - [References](#references)

## Keyword `dyn`
The keyword `dyn` is for **dynamic dispatch**. It directs the compiler not to determine the exact type at the compile time and lets it be determined at the runtime; with some overhead of course.

### Trait Object
Also, it can't be used directly as an argument, since the size of arguments should be determined at the compile time. It has to be used behind the reference or pointer.  

`Pointer<dyn Trait>` kind of values are called trait objects and contains a pointer to a value of exact type and a pointer to the vtable of function pointers. 

## Keyword `impl`
The keyword `impl` is for **static dispatch**. 

### Syntactic Sugar for Anonymous Generic
It is a syntactic sugar for an anonymous generic with trait bound. Therefore, it works without the cover of a pointer. Instead, the keyword directs the compiler to do name mangling and *monomorphization* as generic. Which will make a binary larger, but with no runtime computation cost.

However, the use of `impl` as a return type may not work in many cases. If the exact type of return value could be deferred by the values of arguments, the exact return type of function call could not be determined at the compile time; a trait object would be useful in this case.

## References
1. https://doc.rust-lang.org/1.8.0/book/trait-objects.html
2. https://cotigao.medium.com/dyn-impl-and-trait-objects-rust-fd7280521bea
3. https://github.com/rust-lang/rfcs/blob/master/text/1951-expand-impl-trait.md#the-proposal-in-a-nutshell