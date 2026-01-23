{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (11 pts)
-- 1.  Define a data structure, called D2L, to store lists of possibly depth two, e.g. like [1,2,[3,4],5,[6]].
-- 2.  Implement a flatten function which takes a D2L and returns a flat list containing all the stored values in it
--     in the same order.
-- 3.  Make D2L an instance of Functor, Foldable, Applicative.

data D2L a = D2Nil | D2Cons1 a (D2L a) | D2Cons2 [a] (D2L a) deriving (Show, Eq)

flatten D2Nil = []
flatten (D2Cons1 x xs) = (x : flatten xs)
flatten (D2Cons2 xs ys) = xs ++ flatten ys

instance Functor D2L where
  fmap f D2Nil = D2Nil
  fmap f (D2Cons1 x xs) = D2Cons1 (f x) (fmap f xs)
  fmap f (D2Cons2 xs ys) = D2Cons2 (fmap f xs) (fmap f ys)

instance Foldable D2L where
  foldr f i D2Nil = i
  foldr f i (D2Cons1 x xs) = f x (foldr f i xs)
  foldr f i (D2Cons2 xs ys) = (foldr f (foldr f i ys) xs)

D2Nil +++ t = t
t +++ D2Nil = t
(D2Cons1 x xs) +++ t = D2Cons1 x (xs +++ t)
(D2Cons2 xs ys) +++ t = D2Cons2 xs (ys +++ t)

instance Applicative D2L where
  pure x = D2Cons1 x D2Nil
  fs <*> xs = foldr (+++) D2Nil (fmap (\f -> fmap f xs) fs)