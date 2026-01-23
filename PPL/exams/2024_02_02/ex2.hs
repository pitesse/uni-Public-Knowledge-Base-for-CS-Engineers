{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}

-- Exercise 2, Haskell (11 pts)
-- Consider the following datatype definition.
-- data F b a = F (b -> b) a | Null
-- 1) Make F an instance of Functor, Applicative, and Monad.
-- 2) Using an example, show what >>= does in your implementation.

data F b a = F (b -> b) a | Null

instance Functor (F x) where
  fmap f (F g t) = F g (f t)
  fmap _ Null = Null

instance Applicative (F x) where
  pure = F id
  Null <*> _ = Null
  _ <*> Null = Null
  (F f x) <*> (F g y) = F (f . g) (x y)

instance Monad (F x) where
  Null >>= _ = Null
  F f x >>= g = case g x of
    Null -> Null
    F f' x' -> F (f . f') x'

-- Example
runit (F f x) s = (f s, x)

ex = F (\x -> 2 * x) 5 >>= \x -> pure (x + 1)

-- runit ex 1 -- result: (2,6)