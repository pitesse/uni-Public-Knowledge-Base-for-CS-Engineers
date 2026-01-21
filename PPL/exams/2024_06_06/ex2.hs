{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}

-- Exercise 2, Haskell (12 pts)
-- Consider the following datatype definition.
-- data W x y = W ([x] -> [y])
-- Make W an instance of Functor, Applicative, and Monad.


-- Exercise Definition
data W x y = W ([x] -> [y]) 

-- 1. FUNCTOR
-- Goal: Transform 'y' to 'z' inside the list.
instance Functor (W x) where
  -- We must use 'map' because 'g xs' returns a List [y], not just y.
  fmap f (W g) = W (\xs -> map f (g xs))
  -- Or: fmap f (W g) = W (map f . g)

-- 2. APPLICATIVE
-- Goal: Handle "Environment" (Reader) AND "Multiple Results" (List).
instance Applicative (W x) where
  -- pure: Create a function that ignores input and returns a singleton list.
  pure v = W (\_ -> [v])

  -- (<*>): 
  -- 1. Run 'fg' with input 'xs' -> get List of Functions [f1, f2...]
  -- 2. Run 'g' with input 'xs'  -> get List of Values [v1, v2...]
  -- 3. Combine them using List Applicative logic (apply every f to every v).
  (W fg) <*> (W g) = W (\xs -> (fg xs) <*> (g xs))

-- 3. MONAD
instance Monad (W x) where
  -- (>>=) :: W x a -> (a -> W x b) -> W x b
  (W g) >>= k = W (\xs -> 
      -- 1. Run computation to get list of results [a]
      let vals = g xs 
      -- 2. Process each 'a' to get a new list of 'b's
      in concatMap (\val -> 
             let (W h) = k val -- Unwrap the next function
             in h xs           -- Run it with the ORIGINAL env 'xs'
         ) vals
      )