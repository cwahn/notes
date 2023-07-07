# Procedural Macro
- [Procedural Macro](#procedural-macro)
  - [The `proc-macro` crate](#the-proc-macro-crate)
  - [Procedural Macro Hygiene](#procedural-macro-hygiene)
  - [Function-like Procedural Macro](#function-like-procedural-macro)
  - [Relate Crates](#relate-crates)
    - [`syn`](#syn)
    - [`quote`](#quote)
  - [References](#references)

Procedural macro comes in one of three forms;
- Function-like macro
- Derive macro
- Attribute macro

Procedural macro is roughly equivalent to a function from AST(abstract syntax tree) to AST evaluated at compile time. 

As a function, it either returns syntax, panic, or loop. Panic will be caught by the compiler and will be a compiler error. A loop will not be caught by the compiler and will hang the compiler. 

The procedural macro will report errors in the form of either panic or `compile_error` macro calls.

## The `proc-macro` crate
Compiler provided crate. It primarily contains a `TokenStream` type. Procedural work over token streams instead of AST. A token stream is roughly equivalent to `Vec<TokenTree>`. 

All tokens have associated `Span`. A `Span` is an opaque value that can not be modified but can be manufactured. `Span`s represent an extent of source code in a program and are primarily used for error reporting. One can not modify a `Span` itself but always can change the `Span` associated with any token, such as by getting a `Span` from another token.

## Procedural Macro Hygiene
Procedural macros are *unhygienic*. The outputs of them act as if written inline to the called place. This means they get affected by the external item and also affect external imports.

A macro author should make macros work as may context as possible by for example using absolute path rather than relative path or by making generated identifiers have names unlikely to clash with others.

## Function-like Procedural Macro
Function-like procedural macro is called by using macro invocation operator `!`. These macros are defined as a public function with the `proc_macro` attribute and a signature of `(TokenStream) -> TokenStream`. 

## Relate Crates
### `syn`
`parse :: tokens -> syntex tree`

### `quote`
`quote! :: syntex tree -> tokens` 

## References
- https://doc.rust-lang.org/reference/procedural-macros.html