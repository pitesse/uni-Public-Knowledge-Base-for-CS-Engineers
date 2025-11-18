{--
Consider the following datatype definition.Applicative
data PTL a = P a a | T a a a | L [PLT a] deriving (Show, Eq)
Describe its possible usage , then make PTL an instance of Functor, Foldable and Applicative
--}

data PTL a = P a a | T a a a | L [PTL a] deriving (Show, Eq)

instance Functor PTL where
  fmap f (P x y) = P (f x) (f y)          -- P aa
  fmap f (T x y z) = T (f x) (f y) (f z)  -- T aaa
  -- fmap f (L l) = L (fmap f l)             maybe also work but the one down is better
  fmap f (L xs) = L (map (fmap f) xs)     -- L [PTL a]

instance Foldable PTL where
    foldr f z (P x1 x2) = f x1 (f x2 z)
    foldr f z (T x1 x2 x3) = f x1 (f x2 (f x3 z))
    foldr f z (L xs) = foldr (\ptl acc -> foldr f acc ptl) z xs

instance Applicative PTL where
    pure x = P x x  
    P f g <*> P x y = P (f x) (g y)
    T f g h <*> T x y z = T (f x) (g y) (h z)
    L fs <*> L xs = L [f <*> x | f <- fs, x <- xs]
    _ <*> _ = error "Mismatched PTL structures"