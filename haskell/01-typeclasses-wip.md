# Typeclasses

- [Typeclasses](#typeclasses)
  - [Functor](#functor)
    - [Definition](#definition)
    - [Laws](#laws)
    - [Intuition](#intuition)
    - [Instances](#instances)
  - [Applicative](#applicative)
    - [Definition](#definition-1)
    - [Laws](#laws-1)
    - [Intuition](#intuition-1)
    - [Utility functions](#utility-functions)
    - [Alternative Formulation](#alternative-formulation)
  - [References](#references)

## Functor
### Definition
``` haskell
class Functor f where
    fmap :: a -> b -> f a -> f b
    -- Method for conveniance
    (<$) :: a -> f b -> f a
    (<$) = fmap . const
```

### Laws
``` haskell
fmap id = id
fmap (g. h) = (fmap g) . (fmap h)
```

Unlike any other type classes, a given concrete type could be an instance of at most one Functor. This can be [proven](https://archive.md/U8xIY) by the [free theorem](https://homepages.inf.ed.ac.uk/wadler/topics/parametricity.html#free) for the type of `fmap`.

### Intuition
A Functor could be seen as a 'container' with the ability to apply a function to every element in the container. Another useful point of view is that a Functor represents some sort of 'computation context'. 

`f a` and `f b` implies that `f` is not a concrete type. Indeed the *kind* of `f` should be `* -> *`.

From the 'container' point of view, `fmap` could be seen as applying a function to each element of the container without altering the structure of the container. On the other hand, from the 'context' point of view, `fmap` could be seen as applying a function to a value without altering the context.

`<$` simply changes any Functor instance to the Functor instance with a given value like a constant function.

Just like many other functions which take more than one argument, `fmap` could be seen as a curried form. In this point of view, it could be seen as `fmap :: (a -> b) -> (f a -> f b)` which is often referred to as a *lifting*; `fmap` lifts a function from the 'normal world' to 'f world'. 

### Instances
A list constructor `[]` and maybe constructor `Maybe` are Functor.

``` haskell
instance Functor [] where
    fmap :: (a -> b) -> [a] -> [b]
    fmap _ [] = []
    fmap g (x:xs) = g x : fmap g xss

instance Functor Maybe where
    fmap :: (a -> b) -> Maybe a -> Maybe b
    fmap = _ Nothing = Nothing
    fmap = g (Just a) = Just (g a)
```

In idiomatic Haskell, one uses `f` to represent a Functor, `g`, and `h` to represent a function.

There are other instances of Functor in the standard library; 
1. `Either e` 
2. `((,) e)` (cf. `(e, )` would be a more intuitive form, but it is not allowed in Haskell.)
3. `((->) e)` (cf. Also could be seen as `(e ->)` or any function takes e as an argument.) Alternatively, `((->) e)` could be seen as a context, producing a value of type `e` only available in a read-only manner.
4. `IO`; `IO a` represent computation producing a value of type `a` which may have side effect. If `m` computes value `x` while producing IO-effect, `fmap g x` will produce the same IO-effect, while computing `g x`.
5. `Tree`, `Map`, `Sequence`, etc.

## Applicative
### Definition
``` haskell
class Functor f => Applicative f where
    pure :: a -> f a
    infixl 4 <*>, *>, <*
    (<*>) :: f (a -> b) -> f a -> f b
    -- Methods for conveniance
    (*>) :: f a -> f b -> f b
    a1 *> a2 = (id <$ a1) <*> a2

    (<*) :: f a -> f b -> f a
    (<*) = liftA2 const
```
### Laws
- The identity law:
    ``` haskell
    pure id <*> v = v
    ```
- Homomorphism:
   ``` haskell
   pure f <*> pure x = pure (f x)
   ```
- Interchange:
   ``` haskell
   u <*> pure y = pure (\f -> f y) <*> u
   ```
- Composition:
   ``` haskell
   u <*> (v <*> w) = pure . <*> u <*> v <*> w
   ```

There is also a law specifying how to relate `Applicative` to `Functor`.
``` haskell
fmap g x = pure g <*> x
```

### Intuition
McBride and Paterson's paper introduces a notation for function application in a computational context;

$$
[[ g \ x_1 \ x_2 \ ... \ x_n ]]
$$

where, $x_i$ has type of $f \ t_i$ for a Functor $f$, $g$ has type of $t_1 \rightarrow \ t_2 \ \rightarrow \ ... \ \rightarrow t_n \ \rightarrow \ t$, and the entire expression has type of $f \ t$. The expression represents applying multiple 'effectful' arguments to a function, which is a generalization of `fmap`. `fmap` helps apply a single argument function to 'effectful' argument, but can't help applying the multi-argument function to arguments; application of a function to the first argument left a function under context or container, which `fmap` couldn't help anymore.

The equivalent expression of the above notation is the following. Be advised that `Control.Applicative` defines `(<*>)` as a convenient infix shorthand for `fmap`.

``` haskell
g <$> x_1 <*> x_2 <*> ... <*> x_n
```

Considering left-to-right writing law, homomorphism, interchange, and composition constitute an algorithm to transform any expression with `pure` and `(<*>)` to the canonical form; only one use of `pure` at the very beginning, and left-nested occurrences of `(<*>)`. Composition allows reassociating the `(<*>)`, interchange allows to move `(<*>)` leftward, and homomorphism allows to collapse of multiple adjacent occurrences of `(<*>)` to one.   

### Utility functions
- `liftA :: Applicative f => (a -> b) -> f a -> f b`. This is a  more restrictive version of `fmap`, used for forming `liftA2`, `liftA3`, etc.
- `liftA2 :: Applicatice f => (a -> b -> c) -> f a -> f b -> f c`. It lifts a two-argument function to operation under the context of some Applicative. It allows to write `liftA2 g x_1 x_2` instead of `g <$> x_1 <*> x_2`.
- `(*>) :: Applicative f => f a -> f b -> f b` sequences the effect of two Applicative, but discard the value of the first; i.e. for `m1, m2 :: Maybe Int`, `m1 *> m2` is `Nothing` if `m1` or `m2` is `Nothing`, otherwise `m2`.
- Likewise, `(<*) :: Applicative f => f a -> f b -> f a` discards the value of the second and leave the first.
- `(<**>) :: Applicative f => f a -> (f a -> f b) -> f b` looks like `flip fmap`, but results different values for non-commutative Applicatives.
- `when :: Bool -> f () -> f ()` conditionally executes a computation, evaluating to its second argument if the test is `Ture`, otherwise to `pure ()`.
- `unless :: Bool -> f() -> f()` is the same with `when` but the test negated.

### Alternative Formulation
``` haskell
class Applicative f => Monidal f where
    pure :: f ()
    (**) :: f a -> f b -> f (a, b)
``` 

- Left identity 
  ``` haskell 
  unit ** v ≅ v
  ```
- Right identity
  ``` haskell
  v ** unit ≅ v
  ```
- Associativity
  ``` haskell
  u ** (v ** w) ≅ (u ** v) ** w
  ```

A *monoidal* Functor with satisfying some laws is Applicative. `unit` and `(**)` is equivalent with `pure` and `(<*>)` and the laws are equivalent with the Applicative laws.


## References
1. https://wiki.haskell.org/Typeclassopedia

