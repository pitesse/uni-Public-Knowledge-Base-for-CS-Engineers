{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
-- Exercise 2, Haskell (11 pts)
-- Consider the following data definition:
-- data T a = A | B (T a) a | C a a deriving (Show, Eq)
-- 1) Describe the data structure.
-- 2) Make T an instance of Functor, Foldable, and Applicative.

data T a = A | B (T a) a | C a a deriving (Show, Eq)

-- data struct is a tree, A is a null leaf, b is subtree node, C is double node, basically a tree with only the left side recursive

instance Foldable T where
    foldr _ initial A = initial
    foldr f initial (C a b) = f a (f b initial)
    foldr f initial (B tree val) = foldr f (f val initial) tree

instance Functor T where
    fmap _ A = A
    fmap f (C a b) = C (f a) (f b)
    fmap f (B tree a) = B (fmap f tree) (f a)

merge :: T a -> T a -> T a
merge A t = t
merge t A = t
-- If left side is C, convert to B and merge
merge (C x y) t = merge (B (B A x) y) t
-- If left side is B, push 't' deep into the recursive structure
merge (B left val) t = B (merge left t) val 

-- 4. APPLICATIVE (Combinatorial / List-like)
-- Uses the cheat sheet formula: fs <*> xs = tconcmap ...
instance Applicative T where
    -- pure: Create a singleton list
    pure x = B A x 

    -- (<*>): The "Merge" Strategy
    fs <*> xs = tconcat (fmap (\f -> fmap f xs) fs)
      where
        -- Flatten a tree of trees
        tconcat = foldr merge A




