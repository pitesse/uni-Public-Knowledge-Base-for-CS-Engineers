{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (11 pts)
-- Define a partitioned list data structure, called Part, storing three elements:
-- 1. a pivot value,
-- 2. a list of elements that are all less than or equal to the pivot, and
-- 3. a list of all the other elements.
-- Implement the following utility functions, writing their types:
-- • checkpart, which takes a Part and returns true if it is valid, false otherwise;
-- • part2list, which takes a Part and returns a list of all the elements in it;
-- • list2part, which takes a pivot value and a list, and returns a Part;
-- Make Part an instance of Foldable and Functor, if possible. If not, explain why.

data Part a = Part [a] a [a]
  deriving (Show)

-- Check invariant: left <= pivot < right
checkpart (Part left pivot right) =
  all (<= pivot) left && all (> pivot) right

-- Canonical list representation
part2list (Part l p r) = l ++ [p] ++ r

-- Build from pivot and list
list2part pivot xs = Part smaller pivot larger
  where
    smaller = filter (<= pivot) xs
    larger = filter (> pivot) xs

-- FOLDABLE: via canonical list
instance Foldable Part where
  foldr f z = foldr f z . part2list

-- FUNCTOR: IMPOSSIBLE without breaking invariant!
-- fmap g (Part l p r) would need Ord b to re-partition
-- but Functor signature doesn't allow constraints