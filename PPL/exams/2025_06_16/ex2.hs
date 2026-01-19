{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}

-- Exercise 2, Haskell (11 pts)
-- Consider the following datatype definition.
-- data PTL a = P a a | T a a a | L [PTL a] deriving (Show, Eq)
-- Describe its possible usage, then make PTL an instance of Functor, Foldable, and Applicative.

data PTL a = P a a | T a a a | L [PTL a] deriving (Show, Eq)

instance Functor PTL where
  fmap f (P x y) = P (f x) (f y)
  fmap f (T x y z) = T (f x) (f y) (f z)
  fmap f (L xs) = L (map (fmap f) xs)

instance Foldable PTL where
  foldr f z (P x y) = f x (f y z)
  foldr f z (T x y w) = f x (f y (f w z))
  foldr f z (L xs) = foldr (\ptl acc -> foldr f acc ptl) z xs

instance Applicative PTL where
  pure x = P x x
  (P f g) <*> (P x y) = P (f x) (g y)
  (T f g h) <*> (T x y z) = T (f x) (g y) (h z)
  (L fs) <*> (L xs) = L (apList fs xs)
    where
      apList [] _ = []
      apList _ [] = []
      apList (f : fs) (x : xs) = (f <*> x) : apList fs xs

