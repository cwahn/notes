# Macro
- [Macro](#macro)
  - [Syntex Extension](#syntex-extension)
    - [Source Analysis](#source-analysis)
  - [References](#references)

## Syntex Extension
The way how the rust compiler process Rust source code is closely related to macros.

### Source Analysis
The first step of Rust compilation is "tokenization". The source code text is processed to sequence of tokens such as

- Identifier: `foo`, `Bar`, `self`, ...
- Literals: `42`, `72u32`, ...
- Keywords: `_`, `fn`, `self`, `match`, `macro`, ...
- Symbols: `[`, `:`, `::`, `?`, `~`, `@`, ...

and some others. 

## References
