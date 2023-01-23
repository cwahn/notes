# Lecture 3 Recursion Patterns, Polymorphism, and the Prelude

- [Lecture 3 Recursion Patterns, Polymorphism, and the Prelude](#lecture-3-recursion-patterns-polymorphism-and-the-prelude)
  - [Recursion Patterns](#recursion-patterns)
  - [Polymorphism](#polymorphism)
    - [Polymorphic Data Type](#polymorphic-data-type)
    - [Polymorphic Function](#polymorphic-function)
  - [The Prelude](#the-prelude)
  - [Total and Partial Functions](#total-and-partial-functions)
    - [Replacing Partial Functions](#replacing-partial-functions)
    - [Writing Partial Functions](#writing-partial-functions)
  - [References](#references)

This is a personal note for CIS 194: Introduction to Haskell (Spring 2013).[^1]

## Recursion Patterns
By now, one might think defining recursive functions are a large portion of Haskell programming; it is not actually true. A number of patterns of recursive functions are provided as the default library. An experienced Haskell programmer rarely spends time writing recursive functions by hand, instead focusing on higher lever logic.

- map: Apply an operation to every element of the list
- filter: Keep only some of the elements, and leave the others, based on a predicate.
- fold: Summarize the elements of a list somehow. (e.g. sum, product, maximum, etc.)
- etc.

## Polymorphism
 The word “polymorphic” comes from Greek (πολύμορφος) and means “having many forms”: something which is polymorphic works for multiple types. Haskell supports *polymorphism* both for functions and datatypes 

### Polymorphic Data Type
```haskell
data List t = E | C t (List t)

lst1 :: List Int
lst1 = C 3 (C 5 (C 2 E))

lst2 :: List Char
lst2 = C 'x' (C 'y' (C 'z' E))

lst3 :: List Bool
lst3 = C True (C False E)
```
Given a type `t`, `(List t)` consists of either the constructor `E`, or the constructor `C` along with a value of type `t` and another `(List t)`.

### Polymorphic Function
A function could be generalized by taking polymorphic data types instead of concrete data types and taking functions as arguments instead of hard-coded operations.

One important thing to remember is that **the caller picks the types**. Therefore the function should be working for every possible input type.

## The Prelude
The `Prelude` is a module with many standard definitions which get implicitly imported to every Haskell program. It’s worth spending some time skimming through its documentation[^2] to familiarize oneself with the available tools.

## Total and Partial Functions
One could think of a polymorphic type; `[a] -> a`. For example, the `head` function returning the first element of the input list has a such type. What happens when `[]` comes in as input? It crashes. Nothing else it could do. There is no way to make up a value of arbitrary type out of air.

The `head` is known as a *partial function*; there are certain inputs for which the function will crash. Functions that have certain inputs that will make it recurse infinitely are also called *partial*. Functions that are well-defined for all functions are known as *total* functions.

It is good Haskell practice to avoid the use of *partial functions* as much as possible. It is good practice to avoid *partial functions* for any programming language; Though it is ridiculously annoying. Haskell tends to make it quite easy and sensible. 

The `head` is a mistake, It should not be in the `Prelude`. There are some other functions one should almost never use; `tail`, `init`, `last`, and `(!!)` 

### Replacing Partial Functions
Often partial functions could be replaced by pattern-matching.
```haskell
doStuff1 :: [Int] -> Int
doStuff1 [] = 0
doStuff1 [_] = 0
doStuff1 xs = head xs + (head (tail xs))

-- Replace `head` and `tail`

doStuff2 :: [Int] -> Int
doStuff2 [] = 0
doStuff2 [_] = 0
doStuff2 (x1 : x2 : _) = x1 + x2
```

### Writing Partial Functions
What should one do if one finds writing partial functions? There are two approaches;
1. Indicate possible failure
2. Refelct gurantees on types

```haskell
safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x
```

This is a good idea because:
1. The `safeHead` will never crash.
2. The type of `safeHead` makes it obvious that it may fail for some inputs.
3. The type system ensures the programmer to check the return value of `safeHead` to check if it is `Nothing`. 

In some sense, the function is still 'partial', but the partiality is reflected on the type, which is safe.

What if one will only use a partial function in situations *guaranteed* to have 'safe' inputs. In these case, makes it returns failable types and dealing with cases which one knows never happens would be really annoying.

If some condition is really guaranteed, then the types ought to reflect the guarantee! Then the compiler can enforce your guarantees for you. 

```haskell
data NonEmptyList a = NEL a [a]

nelToList :: NonEmptyList a -> [a]
nelToList (NEL x xs) = x:xs

listToNel :: [a] -> Maybe (NonEmptyList a)
listToNel []     = Nothing
listToNel (x:xs) = Just $ NEL x xs

headNEL :: NonEmptyList a -> a
headNEL (NEL a _) = a

tailNEL :: NonEmptyList a -> [a]
tailNEL (NEL _ as) = as
```

## References

[^1]: https://www.seas.upenn.edu/~cis1940/spring13/lectures/01-intro.html
[^2]: https://hackage.haskell.org/package/base-4.17.0.0/docs/Prelude.html