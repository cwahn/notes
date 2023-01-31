# Lifetime Parameter
- [Lifetime Parameter](#lifetime-parameter)
  - [Rules](#rules)
  - [References](#references)

The subject of reference should outlive the references. 

The *lifetime parameter* is a kind of generic. Most time, lifetimes are implicit and could be inferred. However, it must be annotated explicitly if multiple values are possible. 

In case, the borrow checker and programmer both do not know the concrete lifetime, the lifetime parameter should be specified.

Lifetime parameter annotation does not affect the actual lifetimes but describes the relationship of lifetimes of multiple references. 

Lifetime parameters should start with `` ` `` and usually have short lowercase names.
```rust
&i32        // a reference
&'a i32     // a reference with an explicit lifetime
&'a mut i32 // a mutable reference with an explicit lifetime
```
Lifetimes on function or method parameters are called input lifetimes, and lifetimes on return values are called output lifetimes. 

## Rules
There are three rules that the compiler used to infer output lifetimes. If the compiler gets to the end of the three rules and there are still references for which it can’t figure out lifetimes, the compiler will stop with an error.

1. The compiler assigns a lifetime parameter to each reference parameter.
2. If there is only one reference parameter, the lifetime parameter of the parameter is assigned to all output references.
3. If there are multiple parameters, but one of them is `&self` or `&mut self` (which means the function is a method) the lifetime of `self` is assigned to all the output references. 
[^1]

## References
[^1] https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html