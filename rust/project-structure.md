# Project Structure
- [Project Structure](#project-structure)
  - [Nomenclature](#nomenclature)
  - [Package Layout](#package-layout)
  - [Modules](#modules)
  - [Reference](#reference)

## Nomenclature 
- Package: A Cargo feature for building, testing, and sharing crates
  - A package is a bundle of one or more crates (which could be binary crates either library crates or both).
- Crates: A Tree of modules that produces a library or executable
  - A crate is the smallest amount of code the rust compiler considers at a time. A crate is either; a binary crate or a library crate
  - A binary crate must have a `main` function. A library crate does not have a `main` function.
  - A crate root is a file the rust compiler starts from and makes up the *root module* of a crate.
- Modules and Use: Let one controls the organization, scope, and privacy of paths.
- Paths: A way to name an item, such as struct, function, or module. [^1]

## Package Layout
```
.
├── Cargo.lock
├── Cargo.toml
├── src/
│   ├── lib.rs
│   ├── main.rs
│   └── bin/
│       ├── named-executable.rs
│       ├── another-executable.rs
│       └── multi-file-executable/
│           ├── main.rs
│           └── some_module.rs
├── benches/
│   ├── large-input.rs
│   └── multi-file-bench/
│       ├── main.rs
│       └── bench_module.rs
├── examples/
│   ├── simple.rs
│   └── multi-file-example/
│       ├── main.rs
│       └── ex_module.rs
└── tests/
    ├── some-integration-tests.rs
    └── multi-file-test/
        ├── main.rs
        └── test_module.rs
```

- `Cargo.toml` and `Cargo.lock` is stored in the root of the package.
- The source code goes into the `src/` directory in the root. 
- The default library file is `src/lib.rs`.
- The default executable file is `src/main.rs`.
  - Other executables can be placed in `src/bin/`.
- Benchmarks go into the `benches/` directory.
- Examples go into the `examples/` directory.
- Integration tests go into the `tests/` directory.

If a binary, example, bench, or example consists of multiple files, make a subdirectory and put `main.rs` with modules. The name of the executable will be the name of the subdirectory. [^2]

## Modules 
On compilation, the compiler starts from the crate root; i.e. `src/main.rs` for binary crates, `src/lib.rs` for library crates.

In the crate root file, one could declare modules. The compiler will find the code of the declared modules in the following places;
- Inline 
- In the file `src/<module-name>.rs`
- In the file `src/<module-name>/mod.rs`

In any file other than the crate root, one could declare submodules. The compiler will find the code of the declared submodule in the following places;
- Inline
- In the file `src/<parent-module-name>/<submodule-name>.rs`
- In the file `src/<parent-module-name>/<submodule-name>/mod.rs`

Once a module is part of a crate, one could refer to the code in the module anywhere in the crate with the following form, as long as the privacy rule holds. 
- `crate::<module-name>::<sub-module>:: ... ::<item>`
  
A module is by default, private from its parent module. One should make the module public by declaring it public; i.e. `pub mod <module-name>`. To make items within a public module public as well, use `pub` before their declarations.

One could use the `use` keyword to reduce repetition; i.e. `use crate::<module-name>::<sub-module>:: ... ::<item>` first, and just `<item>`.  


## Reference
[^1]: https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html
[^2]: https://doc.rust-lang.org/cargo/index.html