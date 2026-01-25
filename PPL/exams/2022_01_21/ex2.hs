{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (10 pts)
-- Consider a Tvtl (two-values/two-lists) data structure, which can store either two values of a given type, or
-- two lists of the same type.
-- Define the Tvtl data structure, and make it an instance of Functor, Foldable, and Applicative.

data Tvtl a = Tv a a | Tl [a] [a]
  deriving (Show, Eq)

-- 1. Standard Functor
instance Functor Tvtl where
  fmap f (Tv x y) = Tv (f x) (f y)
  fmap f (Tl l r) = Tl (map f l) (map f r)

-- 2. Standard Foldable 
instance Foldable Tvtl where
  foldr f acc (Tv x y) = f x (f y acc)
  foldr f acc (Tl l r) = foldr f (foldr f acc r) l

-- 3. The "Merge" Applicative Strategy
instance Applicative Tvtl where
  -- pure: The simplest container is just two values
  pure x = Tv x x

  -- (<*>): Combinatorial logic (Map then Merge)
  fs <*> xs = foldr merge empty (fmap (\f -> fmap f xs) fs)
    where
      -- A "Zero" element to start the fold
      empty = Tl [] []

      -- Helper to normalize any node into a pair of lists
      toLists (Tv a b) = ([a], [b])
      toLists (Tl l r) = (l, r)

      -- The Merge Function: Normalizes inputs and appends them
      merge t1 t2 =
        let (l1, r1) = toLists t1
            (l2, r2) = toLists t2
         in Tl (l1 ++ l2) (r1 ++ r2)