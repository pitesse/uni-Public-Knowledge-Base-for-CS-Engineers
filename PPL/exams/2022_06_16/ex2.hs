{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (12 pts)
-- Consider the "fancy pair" data type (called Fpair), which encodes a pair of the same type a, and may
-- optionally have another component of some "showable" type b, e.g. the character '$'.
-- Define Fpair, parametric with respect to both a and b.
-- 1)  Make Fpair an instance of Show, where the implementation of show of a fancy pair e.g. encoding
--     (x, y, '$') must return the string "[x$y]", where x is the string representation of x and y of y. If the third
--     component is not available, the standard representation is "[x, y]".
-- 2)  Make Fpair an instance of Eq — of course the component of type b does not influence the actual
--     value, being only part of the representation, so pairs with different representations could be equal.
-- 3)  Make Fpair an instance of Functor, Applicative and Foldable.

data Fpair s a = Fpair a a s | Pair a a

instance (Show a, Show s) => Show (Fpair s a) where
  show (Fpair x y t) = "[" ++ (show x) ++ (show t) ++ (show y) ++ "]"
  show (Pair x y) = "[" ++ (show x) ++ ", " ++ (show y) ++ "]"

simplify (Fpair x y _) = (x, y)
simplify (Pair x y) = (x, y)

instance (Eq a) => Eq (Fpair s a) where
  x == y = (simplify x) == (simplify y)

instance Functor (Fpair s) where
  fmap f (Fpair x y t) = (Fpair (f x) (f y) t)
  fmap f (Pair x y) = (Pair (f x) (f y))

instance Applicative (Fpair s) where
  pure x = (Pair x x)
  (Fpair f g _) <*> (Fpair x y v) = Fpair (f x) (g y) v
  (Pair f g) <*> (Fpair x y v) = Fpair (f x) (g y) v
  (Fpair f g v) <*> (Pair x y) = Fpair (f x) (g y) v
  (Pair f g) <*> (Pair x y) = Pair (f x) (g y)

instance Foldable (Fpair s) where
  foldr f i (Fpair x y _) = (f x (f y i))
  foldr f i (Pair x y) = (f x (f y i))