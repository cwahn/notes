# Lecture 3 Recursion Patterns, Polymorphism, and the Prelude

- [Lecture 3 Recursion Patterns, Polymorphism, and the Prelude](#lecture-3-recursion-patterns-polymorphism-and-the-prelude)
  - [Recursion Patterns](#recursion-patterns)
  - [Polymorphism](#polymorphism)
    - [Polymorphic Data Type](#polymorphic-data-type)
    - [Polymorphic Function](#polymorphic-function)
  - [The Prelude](#the-prelude)
    - [Basic Data Types](#basic-data-types)
    - [Basic Typeclasses](#basic-typeclasses)
    - [Numbers](#numbers)
    - [Numeric Typeclasses](#numeric-typeclasses)
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

### Basic Data Types
- `data Bool = False | True`
- `(&&) :: Bool -> Bool -> Bool`
- `(||) :: Bool -> Bool -> Bool`
- `not :: Bool -> Bool`
- `data Maybe a = Nothing | Just a`
- `maybe b -> (a -> b) -> Maybe a -> b`
  - Takes a default value, a function, and a `Maybe` value and returns the default value if the `Maybe` value is `Nothing`. Otherwise, applies the function to the value inside the `Maybe` value and return the result.
- `data Either a b = Left a | Right b`
- `either :: (a -> c) -> (b -> c) -> Either a b -> c`
  - If `Either` value is `Left`, it applies the first function, otherwise, applies the second function and returns the result.
- `data Ordering = LT | EQ | GT`
- `data Char`
- `type String = [Char]`
- `fst :: (a, b) -> a`
- `snd :: (a, b) -> b`
- `curry :: ((a, b) -> c) -> a -> b -> c`
  - It converts an uncurried function to a curried function.
- `uncurry :: a -> b -> c -> ((a, b) -> c)`
  - It converts a curried function to a function on a pair.

### Basic Typeclasses
- ```haskell
  class Eq a where
    (==) :: a -> a -> Bool -- or
    (/=) :: a -> a -> Bool 
  ```
- ```haskell
  class Eq a => Ord a where
    compare :: a -> a -> Ordering -- or
    (<=) :: a -> a -> Bool 
  ```
- ```haskell
  class Enum a where
    toEnum :: Int -> a
    fromEnum :: a -> Int
  ```
- ```haskell
  class Bounded a where
  ```
  - It could be derived for any `Enum` type and also may be derived for a single-constructor type whose constituents types are also in `Bounded`.

### Numbers
- `data Int`
  - A fixed-precision integer type with at least the range [-2^29 .. 2^29-1]. The exact range for a given implementation can be determined by using `minBound` and `maxBound` from the Bounded class.
- `data Interger`
  - Arbitrary precision integers. In contrast with fixed-size integral types such as Int, the Integer type represents the entire infinite range of integers.  
  Integers are stored in a kind of sign-magnitude form, hence do not expect two's complement form when using bit operations.  
  If the value is small (fit into an Int), IS constructor is used. Otherwise Integer and IN constructors are used to store a BigNat representing respectively the positive or the negative value magnitude.
- `data Float`
  - Single-precision floating point numbers. It is desirable that this type be at least equal in range and precision to the IEEE single-precision type.
- `data Double`
  - Double-precision floating point numbers. It is desirable that this type be at least equal in range and precision to the IEEE double-precision type.
- `type Rational = Ratio Integer`
  - Arbitrary-precision rational numbers, represented as a ratio of two Integer values. A rational number may be constructed using the `%` operator.
- `data Word`
  - A Word is an unsigned integral type, with the same size as Int.

### Numeric Typeclasses
- ```haskell
  class Num a where
    (+) :: a -> a -> a
    (*) :: a -> a -> a
    abs :: a -> a
    signum :: a -> a
    fromInteger :: Integer -> a
    negate :: a -> a
  ```
- ```haskell
  class (Num a, Ord a) => Real a where
  ```
- ```haskell
  class (Real a, Enum a) => Integeral a where
    quotRem :: a -> a -> (a , a)
    toInteger :: a -> Integer  
  ```
- ```haskell
  class Num a => Fractional a where
    fromRational :: Rational -> a
    recip :: a -> a
  ```
- ```haskell
  class Fractional a => Floating a where
    pi :: a
    exp :: a -> a
    log :: a -> a
    sin :: a -> a
    cos :: a -> a
    asin :: a -> a
    acos :: a -> a
    atan :: a -> a
    sinh :: a -> a
    cosh :: a -> a
    asinh :: a -> a
    acosh :: a -> a
    atanh :: a -> a
  ```
- ```haskell
  class (Real a, Fractional a) => RealFrac a where
    properFraction :: Integeral b => a -> (b, a)
  ```
  - The function `properFraction` takes a real fractional number x and returns a pair (n,f) such that x = n+f, and:
    - n is an integral number with the same sign as x; and
    - f is a fraction with the same type and sign as x, and with absolute value less than 1.
- ```haskell
  class (RealFrac a, Floating a) => RealFloat a where
    floatRadix :: Integer -> a
    floatDigits :: a -> Int
    floatRange :: a -> (a, a)
    decodeFloat :: a -> (Integer, Int)
    encodeFloat :: Integer -> Int -> a
    isNaN :: a -> Bool
    isInfinite :: a -> Bool
    isDenormalized :: a -> Bool
    isNegativeZero :: a -> Bool
    isIEEE :: a -> Bool
  ```

### Numeric Functions
- `subtract :: Num a => a -> a -> a`
- `even :: Integeral a => a -> Bool`
- `odd :: Integeral a => a -> Bool`
- `gcd :: Integeral a => a -> a -> a`
- `lcm :: Integeral a => a -> a -> a`
- `(^) :: (Num a, Integeral b) => a -> b -> a`
- `(^^) :: (Fractional a, Integeral b) => a -> b -> a`
- `fromIntegeral :: (Integeral a, Num b) => a -> b`
- `realToFrac :: (Real a, Fractional b) => a -> b`

### Semigroup and Monoid
- ```haskell
  class Semigourp a where
    (<>) :: a -> a -> a
    
  -- Laws
  -- Associativity
  a <> (b <> c) == (a <> b) <> c
  ```
- ```haskell
  class Semigroup a => Monoid a where
    mempty :: a

  -- Laws 
  -- Left identity
  mempty <> a == a
  -- Right identity
  a <> mempty == a
  -- Associativity
  a <> (b <> c) == (a <> b) <> c
  -- Concatenation
  mconcat = foldr <> mempty
  ```

### Monads and Functors
- ```haskell
  class Functor f where
    fmap :: (a -> b) -> f a -> f b

  -- Laws
  -- Identity
  fmap id = id
  -- Composition
  fmap (f . g) = fmap f . fmap g
  ```
- ```haskell
  class Functor f => Applicative f where
    pure :: a -> f a
    -- Either (<*>) or liftA2
    <*> :: f (a -> b) -> f a -> f b
    liftA2 :: (a -> b -> c) -> f a -> f b -> f c

  -- Laws
  -- Identity 
  pure id <*> v = v
  -- Composition
  pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
  -- Homomorphism
  pure f <*> pure x = pure (f x)
  -- Interchange
  u <*> pure y = pure (\f -> f y) <*> u  
  ```
- ```haskell
  class Applicative m => Monad m where
    (>>=) :: m a -> (a -> m b) -> m b
    return = pure

  -- Laws
  -- Left identity
  return a >>= k = k a
  -- Right identity
  a >>= return = a
  -- Associativity
  m >>= (\x -> k x >> = h) = (m >>= k) >>= h
  ```
- ```haskell
  class Monad m => MonadFail m where
    WIP
  ```
  
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