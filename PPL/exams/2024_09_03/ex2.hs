{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
-- Exercise 2, Haskell (11 pts)
-- Consider the following data structure, implementing a "double content" list:
-- data Llist b a = Nod a b (Llist b a) | Nul deriving (Show, Eq)
-- 1) Make Llist an instance of Functor and Foldable.
-- 2) We cannot make it an instance of Applicative, as it is: why? Make Llist Bool an instance of Applicative.


data Llist b a = Nod a b (Llist b a) | Nul
  deriving (Show, Eq)

instance Functor (Llist b) where
  fmap _ Nul = Nul
  fmap f (Nod x y rest) = Nod (f x) y (fmap f rest)

instance Foldable (Llist b) where
  foldr _ acc Nul = acc
  foldr f acc (Nod x y rest) = f x (foldr f acc rest)

merge :: Llist b a -> Llist b a -> Llist b a
merge Nul right = right
merge (Nod x y rest) right = Nod x y (merge rest right)

instance Applicative (Llist Bool) where
  pure x = Nod x True Nul
  fs <*> xs = foldr merge Nul (fmap (\f -> fmap f xs) fs)