{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (10 pts)
-- We want to implement a binary tree where in each node is stored data, together with the number of nodes
-- contained in the subtree of which the current node is root.
-- 1. Define the data structure.
-- 2. Make it an instance of Functor, Foldable, and Applicative.

data Tree a = Node (Tree a) a Int (Tree a) | Leaf

getSize Leaf = 0
getSize (Node _ _ c _) = c

makeNode l x r = Node l x (1 + getSize l + getSize r) r

instance Functor Tree where
  fmap _ Leaf = Leaf
  fmap f (Node l x c r) = Node (fmap f l) (f x) c (fmap f r)

instance Foldable Tree where
  foldr _ z Leaf = z
  foldr f z (Node l x _ r) = foldr f (f x (foldr f z r)) l

merge Leaf t = t
merge t Leaf = t
merge (Node l x _ r) t = makeNode l x (merge r t)

instance Applicative Tree where
  pure x = makeNode Leaf x Leaf
  fs <*> xs = foldr merge Leaf (fmap (\f -> fmap f xs) fs)