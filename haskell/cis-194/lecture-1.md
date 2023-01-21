## Declarations and variable 

``` haskell
x :: Int 
x = 1

-- Interpretation of below will not terminate
y :: Int
y = y + 1
```

The first line declares the type of `x` and the second line declares the value of `x` is 1. 

## Basic Types

``` haskell
-- Machine sized integer
i :: Int
i = 1

-- Biggest int, smallest int
biggestInt, smallestInt :: Int
biggestInt = maxBound
smallestInt = minBound

-- Artitrary-precision integer
n :: Integer
n = 1234567890987654321987340982334987349872349874534

reallyBigInt :: Int
reallyBigInt = 2^(2^(2^(2^2)))

numDigits :: Int 
numDigits = length (show reallyBigInt)

-- Double-precision floating-point
d1, d2 :: Double
d1 = 3.141592
d2 = 2.7182e0

-- Single-precition floating-point is 'Float'

-- Boolean
b1, b2 :: Bool
b1 = True
b2 = Flase

-- Unicode charicter
c1, c2, c3 :: Char
c1 = 'x'
c2 = 'Ø'
c3 = 'ダ'

-- String is a list of Char with special syntex
s :: String
s = "Hello, Haskell!"
```

## GHCi
GHCi is a REPL(Read-Eval-Print-Loop) for Haskell. One can load Haskell files with `:load` or `:l`, or reload them with `:reload` or `:r`, and ask types of expressions with `:type` or `:t`.

## Arithmatic
``` haskell
ex1 = 1 + 2
ex2 = 4 - 3
ex3 = 5 * 6
ex4 = 7.1 / 8.1
ex5 = 9 `div` 10
ex6 = 12 `mod` 11
ex7 = mod 14 13
ex8 = 15 ^ 16
ex9 = (-17) * (-18)
```
Note that the 'backticks` make a function name into an infix operator. 

Haskell does no implicit conversion; all the conversions should be done explicitly. 
- `fromInteger`: convert an `Int` or `Integer` type value to any other numeric type value.
- `round`, `floor`, `ceiling`: convert a `Float` or `Double` type value to an `Int` or `Integer` type value. 

The `(/)` operator is for floating-point type division, and `div` is for integer type division.

## Boolean Logic
Boolean operations are supported with `(&&)`(logic and), `(||)`(logic or), and `not`(logic negation) operators.

``` haskell
ex10 = True && False
ex11 = not (True || False)
```

Some values can be compared for equality with `(==)`, and `(\=)`, or compared for ordering with `(>)`, `(<)`, `(=>)`, and `(=<)`.
``` haskell
ex12 = 'a' == 'a'
ex13 = (1 \= 2)
ex14 = (3 > 4) && ('b' <= 'c')
ex15 = "haskell" > "C++"
```

Haskell also has an if-expression; `if p then t else f`. Note that the if-statement supported by many languages does not require `else f` and it means doing nothing if `p` is `False`, but Haskell requires `else f` since the expression should always result in some value.

## Defining Basic Functions
``` haskell
sumtorial :: Integer -> Integer
sumtorial 0 = 0
sumtorial n = n + sumtorial (n-1)
```
Note that the first line is declaring the type of the function and should be read as ''sumtorial' has the type of `Integer -> Integer`' or ''sumtorial' has the type of takes one `Integer` argument and results in an `Integer` value'. The clauses of the second and third lines define the body of the function. Each clause is matched in order from top to bottom. 

Choices could also be specified by predicates in *guards*. Any number of guards could be associated with each clause of a function definition.
``` haskell
hailstone :: Integer -> Integer
hailstone n
  | n `mod` 2 == 0 = n `div` 2
  | otherwise = 3 * n + 1
```

## Pair
``` haskell
p :: (Int, Char)
p = (1, 'a')
```
`(x, y)` notation is used both for a pair of types and pair of values.

``` haskell
-- The elements of a pair could be extracted by the pattern matching.
sumPair :: (Int, Int) -> Int
sumPair (x, y) = x + y
```

## Using Functions and Multiple Arguments
``` haskell
f :: Int -> Int -> Int -> Int
f a b c = a + b + c
```
One should write the type of a function taking multiple arguments as `Arg1Type -> Arg2Type -> ... -> ReturnType`. 

Note that function application has higher precedence than any infix operator.
```haskell
-- e.g. In case one would like to pass 1, n+1, 2 as arguments, the below expression 
f 1 n + 1 2
-- will get parsed as below.
(f 1 n) + (1 2)
-- Instead one sould write
f 1 (n + 1) 2
```

## Lists
```haskell
nums, range1, range2 :: [Int]
nums = [1, 2, 3]
range1 = [1 .. 100]
range2 = [1, 3 .. 100]
```

The `String` is just an abbreviation of `[Char]`.
```haskell
-- hello1 and hello2 are exactly the same.
hello1 :: String
hello1 = "hello"

hello2 :: [Char]
hello2 = ['h', 'e', 'l', 'l', 'o']

helloTheSame = hello1 == hello2
```

## Constructing Lists
The simplest list possible is an empty list. The other lists could be constructed with the cons operator `(:)` which takes an element and list and return a new list that the element prepended to the list.
```haskell
emptyList = []
ex16 = 1 : []
ex17 = 1 : (2 : [])
ex18 = 1 : 2 : 3 : []

ex19 = [1, 2, 3] == 1 : 2 : 3 : []
```

One could write a hailstone sequence function as below
``` haskell
hailstoneSeq :: Int -> [Int]
hailstoneSeq 1 = [1]
hailstoneSeq n = n : hailstoneSeq(hailstone n)
```

## Function on Lists
``` haskell
lenList :: [Integer] -> Integer
lenList [] = 0
lenList (x : xs) = 1 + lenLsit xs
```
One could also nest patterns.
``` haskell
sumEveryTwo :: [Integer] -> [Integer]
sumEveryTwo [] = []
sumEveryTwo (x:[]) = [x]
sumEveryTwo (x:(y:zs)) = (x + y) : sumEveryTwo zs
``` 

## Combining Functions
``` haskell
hailstoneLen :: Integer -> Integer
hailstoneLen n = lenList (hailstonseq n) - 1
```




## Reference
1. https://www.seas.upenn.edu/~cis1940/spring13/lectures/01-intro.html