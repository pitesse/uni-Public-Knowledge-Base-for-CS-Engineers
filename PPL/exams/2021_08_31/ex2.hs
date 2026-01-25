{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (11 pts)
-- Consider a Slist data structure for lists that store their length. Define the Slist data structure, and make it
-- an instance of Foldable, Functor, Applicative and Monad.

data Slist a = Slist Int [a] deriving (Show, Eq)

-- Helper: Extracts raw list (useful for instances)
getList (Slist _ xs) = xs

-- Smart Constructor: Calculates length once
makeSlist v = Slist (length v) v

instance Foldable Slist where
  foldr f i (Slist _ xs) = foldr f i xs

instance Functor Slist where
  -- Optimization: Reuse 'n' because map doesn't change length
  fmap f (Slist n xs) = Slist n (fmap f xs)

instance Applicative Slist where
  pure v = Slist 1 [v]

  -- Optimization: Length is Product of lengths (x * y)
  (Slist x fs) <*> (Slist y xs) = Slist (x * y) (fs <*> xs)

instance Monad Slist where
  return = pure
  (Slist _ xs) >>= f = makeSlist (xs >>= (getList . f))