{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (11 pts)
-- Consider the binary tree data structure as seen in class.
-- 1. Define a function btrees which takes a value x and returns an infinite list of binary trees, where:
--    1. all the leaves contain x,
--    2. each tree is complete,
--    3. the first tree is a single leaf, and each tree has one level more than its previous one in the list.

-- 2. Define an infinite list of binary trees, which is like the previous one, but the first leaf contains the integer 1,
-- and each subsequent tree contains leaves that have the value of the previous one incremented by one.
-- E.g. [Leaf 1, (Branch (Leaf 2)(Leaf 2), ...]

-- 3. Define an infinite list containing the count of nodes of the trees in the infinite list of the previous point.
-- E.g. [1, 3, ...]
-- Write the signatures of all the functions you define.

data Btree a = Leaf a | Branch (Btree a) (Btree a) deriving (Show, Eq)

instance Functor Btree where
  fmap f (Leaf x) = Leaf (f x)
  fmap f (Branch x y) = Branch (fmap f x) (fmap f y)

btrees :: a -> [Btree a]
btrees x = (Leaf x) : [Branch t t | t <- btrees x]

incBtrees :: [Btree Integer]
incBtrees = (Leaf 1) : [Branch (fmap (+1) t) (fmap (+1) t) | t <- incBtrees]

counts :: [Integer]
counts = map (\x -> 2 ^ x - 1) [1 ..]