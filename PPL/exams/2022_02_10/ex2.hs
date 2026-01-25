{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (12 pts)
-- Consider a data structure Gtree for general trees, i.e. trees containg some data in each node, and a
-- variable number of children.
-- 1. Define the Gtree data structure.
-- 2. Define gtree2list, i.e. a function which translates a Gtree to a list.
-- 3. Make Gtree an instance of Functor, Foldable, and Applicative.

data Gtree a = Tnil | Gtree a [Gtree a] deriving (Show)

gtree2list Tnil = []
gtree2list (Gtree x xs) = x : concatMap gtree2list xs

instance Functor Gtree where
  fmap f Tnil = Tnil
  fmap f (Gtree x xs) = Gtree (f x) (fmap (fmap f) xs)

instance Foldable Gtree where
  foldr f i t = foldr f i $ gtree2list t

Tnil +++ x = x
x +++ Tnil = x
(Gtree x xs) +++ (Gtree y ys) = Gtree y ((Gtree x [] : xs) ++ ys)

gtconcat = foldr (+++) Tnil

gtconcatMap f t = gtconcat $ fmap f t

instance Applicative Gtree where
  pure x = Gtree x []
  x <*> y = gtconcatMap (\f -> fmap f y) x