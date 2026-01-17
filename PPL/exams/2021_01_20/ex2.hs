-- HASKELL
import Control.Monad.State

-- Consider the following data structure for general binary trees:

--   data Tree a = Empty | Branch (Tree a) a (Tree a) deriving (Show, Eq)

-- Using the State monad as seen in class:

-- 1) Define a monadic map for Tree, called mapTreeM.

-- 2) Use mapTreeM to define a function which takes a tree and returns a tree containing list of
--     elements that are all the data found in the original tree in a depth-first visit.

-- E.g.
-- From the tree: (Branch (Branch Empty 1 Empty) 2 (Branch (Branch Empty 3 Empty) 4 Empty))
-- we obtain:
-- Branch (Branch Empty [1] Empty) [1,2] (Branch (Branch Empty [1,2,3] Empty) [1,2,3,4] Empty)

data Tree a = Empty | Branch (Tree a) a (Tree a) deriving (Show, Eq)

mapTreeM :: (Monad m) => (a -> m b) -> Tree a -> m (Tree b)
mapTreeM f Empty = pure Empty
mapTreeM f (Branch l x r) = do
  l' <- mapTreeM f l
  x' <- f x
  r' <- mapTreeM f r
  pure (Branch l' x' r')

depthTree :: Tree a -> Tree [a]
depthTree t = evalState (mapTreeM visitNode t) []
  where
    visitNode v = do
      cur <- get -- retrieve the current state, which is the list of visited elements so far
      put (cur ++ [v]) -- append the current value to the state (depth-first traversal order)
      get -- return the updated state as the value for the current node