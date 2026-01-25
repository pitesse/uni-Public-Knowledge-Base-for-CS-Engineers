{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}
{- HLINT ignore "Use camelCase" -}
{- HLINT ignore "Use any" -}

-- Exercise 2, Haskell (11 pts)
-- 1) Define a "generalized" zip function which takes a finite list of possibly infinite lists, and returns a
-- possibly infinite list containing a list of all the first elements, followed by a list of all the second elements,
-- and so on.
-- E.g. gzip [[1,2,3],[4,5,6],[7,8,9,10]] ==> [[1,4,7],[2,5,8],[3,6,9]]
-- 2) Given an input like in 1), define a function which returns the possibly infinite list of the sum of the two
-- greatest elements in the same positions of the lists.
-- E.g. sum_two_greatest [[1,8,3],[4,5,6],[7,8,9],[10,2,3]] ==> [17,16,15]

-- 1. Transpose / Generalized Zip
gzip :: [[a]] -> [[a]]
gzip xs
  -- "filter null xs" finds empty lists. If result is NOT null,
  -- it means we found an empty list, so we stop.
  | not (null (filter null xs)) = []
  | otherwise = map head xs : gzip (map tail xs)

-- 2. Logic to find top 2
updateMax :: (Ord a) => a -> (a, a) -> (a, a)
updateMax v (m1, m2)
  | v >= m1 = (v, m1) -- Correct: Shift old max down
  | v > m2 = (m1, v) -- Correct: Replace second max
  | otherwise = (m1, m2)

getSum :: (Ord a, Num a) => [a] -> a
getSum (x : y : rest) =
  let (m1, m2) = foldr updateMax (max x y, min x y) rest
   in m1 + m2
getSum _ = 0 -- Safety for lists with < 2 items

-- 3. Final Function
sum_two_greatest :: (Ord a, Num a) => [[a]] -> [a]
sum_two_greatest xs =
  [getSum column | column <- gzip xs]