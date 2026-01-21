{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}

-- Exercise 2, Haskell (11 pts)
-- Consider the following datatype definition.
-- data T x y z = T (x -> y -> z)
-- Make T an instance of Functor, Applicative, and Monad. (Hint: follow the types.)


data T x y z = T (x -> y -> z)

instance Functor (T x y) where
    fmap h (T g) = T (\x y -> h (g x y))
--or fmap h (T g) = T ((h .) . g)
instance Applicative (T x y) where
  pure v = T (\_ _ -> v)
  (T f) <*> (T g) = T (\x y -> (f x y) (g x y))

instance Monad (T x y) where
  -- (>>=) :: T x y a -> (a -> T x y b) -> T x y b
  (T g) >>= k = T (\x y ->       -- 1. Accept BOTH environment vars
    let 
        val = g x y              -- 2. Run first computation with BOTH vars
        (T h) = k val            -- 3. Generate next computation
    in 
        h x y)                   -- 4. Run next computation with BOTH vars