# Lecture 2 Algebraic Data Types
- [Lecture 2 Algebraic Data Types](#lecture-2-algebraic-data-types)
  - [Enumeration Types](#enumeration-types)
  - [Beyond Enumerations](#beyond-enumerations)
  - [Algebraic Data Type in General](#algebraic-data-type-in-general)
  - [Pattern-Matching](#pattern-matching)
  - [Case Expressions](#case-expressions)
  - [Recursive Data Types](#recursive-data-types)
  - [References](#references)

This is a personal note for CIS 194: Introduction to Haskell (Spring 2013).[^1]

## Enumeration Types
```haskell
data Parity = Odd
  | Even
  deriving Show
```

`deriving Show` direct compiler to generate default code converting the data to `String`. 

```haskell
parity :: Parity
parity = Odd

listOfParities :: [Parity]
listOfParities = [Odd, Even, Even, Odd, Even]
```
```haskell
isEven :: Parity -> Bool
isEven Odd = False
isEven _ = True
```
## Beyond Enumerations
```haskell
data FailableDouble = Failure
  | Ok Double
  deriving Show
```
`Failure` is a value of the `FailableDouble` type, but `Ok` by itself is not a value of the `FailableDouble` type; it takes an argument of type `Double`. For example, `Ok 3.14` is a value of `FailableDouble` type.

```haskell 
failureToZero :: FailableDouble -> Double
failureToZero Failure = 0
failureToZero (Double d) = d
```
```haskell
data Person = Person String Int
  deriving Show

john :: Person
john = Person "John" 99

getAge :: Person -> Int
getAge (Person _ age) = age
```
Notice how the type constructor and data constructor are both named `Person`, but they inhibit in different namespaces and different things. It is idiomatic to give the same name for the type and data constructor of a one-constructor type. 

## Algebraic Data Type in General
```haskell
data Adt = Constr1 Type11 Type12
  | Constr2  
  | Constr3 Type31
```
The code above specifies that a value of `Adt` type could be constructed in one of the four ways; `Constr1`, `Constr2`, and `Constr3`. 

The name of a type and type constructor should start with an uppercase letter, and the name of a variable(including function name) should start with a lowercase letter.

## Pattern-Matching
Fundamentally, pattern-matching is about taking apart a value by *finding out which constructor* it was built with. This information can be used as the basis for deciding what to do; indeed, in Haskell, this is the only way to make a decision.

Note that parentheses are required for patterns consisting of more than one constructor.

Here are the main ideas of pattern-matching. 

1. `_` could be used as the wildcard to match anything.
2. `a@pat` can be used to match pattern `pat`, and also gives name `a` to the entire value being matched.
3. Patterns can be nested.

```haskell
pat ::= _
  | var
  | var @ (pat)
  | ( Constructor pat1 pat2 ... patn )
```

One could think of literal values as constructors with no arguments.
```haskell
data Int  = 0 | 1 | -1 | 2 | -2 | ...
data Char = 'a' | 'b' | 'c' | ...
```

## Case Expressions
```haskell
case exp of
  | pat1 -> exp1
  | pat2 -> exp2
```
Syntex for function definition is just a synthetic sugar for the case expressions.

## Recursive Data Types
Data types of Haskells could be recursive.
```haskell
data IntList = Nil | Cons Int IntList
```
One often use recursive function to process recursive datatype.
```haskell 
SumIntList :: IntList -> Int
SumIntList Nil = 0
SumIntList (Cons x xs) = x + SumIntList xs
```

## References

[^1]: https://www.seas.upenn.edu/~cis1940/spring13/lectures/01-intro.html