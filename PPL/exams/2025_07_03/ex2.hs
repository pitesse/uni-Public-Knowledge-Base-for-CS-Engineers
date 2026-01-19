{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}

-- Exercise 2, Haskell
-- Hamming numbers are the numbers whose only prime divisors are 2, 3, and 5. Formally, a Hamming number n is
-- an integer of the form n = 2i 3j 5k, for i, j, k natural numbers.
-- Define the infinite list of Hamming numbers, with type hamming :: [Integer].

-- Ordered merge of two infinite sorted lists (removes duplicates)
merge xs@(x:xt) ys@(y:yt)
  | x < y     = x : merge xt ys          -- take smaller
  | x > y     = y : merge xs yt          -- take smaller
  | otherwise = x : merge xt yt          -- equal: take once, skip both
merge [] ys = ys
merge xs [] = xs

-- Hamming numbers: 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, ...
-- Numbers whose only prime factors are 2, 3, and 5
hamming :: [Integer]
hamming = 1 : merge (map (2*) hamming)
                    (merge (map (3*) hamming)
                           (map (5*) hamming))


