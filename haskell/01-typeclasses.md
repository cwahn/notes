# Haskell Typeclasses
## Functor
### Definition
``` haskell
class Functor f where
    fmap :: a -> b -> f a -> f b
    -- Convenient methods
    (<$) :: a -> f a -> f b
    (<$) = fmap . const
```
### Intuition
A Functor could be seen as a 'container' with the ability to apply a function to every element in the container. Another useful point of view is that a Functor represents some sort of 'computation context'. 

`f a` and `f b` implies that `f` is not a concrete type. Indeed the *kind* of `f` should be `* -> *`.

From the 'container' point of view, `fmap` could be seen as applying a function to each element of the container without altering the structure of the container. On the other hand, from the 'context' point of view, `fmap` could be seen as applying a function to a value without altering the context.

`<$` simply changes any Functor instance to the Functor instance with given value like a constant function.

### Instances
A list constructor `[]` and maybe constructor `Maybe` are Functor.

``` haskell
instance Functor [] where
    fmap :: (a -> b) -> [a] -> [b]
    fmap _ [] = []
    fmap g (x:xs) = g x : fmap g xs

instance Functor Maybe where
    fmap :: (a -> b) -> Maybe a -> Maybe b
    fmap = _ Nothing = Nothing
    fmap = g (Just a) = Just (g a)
```

In idiomatic Haskell, one uses `f` to represent a Functor, `g`, and `h` to represent a function.

There are other instances of Functor in standard library; 
1. `Either e` 
2. `((,) e)` (cf. `(e, )` would be a more intuitive form, but it is not allowed in Haskell.)
3. `((->) e)` (cf. Also could be seen as `(e ->)` or any function takes e as an argument.) Alternatively, `((->) e)` could be seen as a context, producing a value of type `e` only available in a read-only manner.
4. `IO`; `IO a` represent computation producing a value of type `a` which may have side effect. If `m` computes value `x` while producing IO-effect, `fmap g x` will produce the same IO-effect, while computing `g x`.
5. `Tree`, `Map`, `Sequence`, etc.

## References
1. https://wiki.haskell.org/Typeclassopedia

