{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (11 pts)
-- We want to define a data structure for binary trees, called BBtree, where in each node are stored two values of the
-- same type. Write the following:
-- 1. The BBtree data definition.
-- 2. A function bb2list which takes a BBtree and returns a list with the contents of the tree.
-- 3. Make BBtree an instance of Functor and Foldable.
-- 4. Make BBtree an instance of Applicative, using a “zip-like” approach, i.e. every function in the first
--    argument of <*> will be applied only once to the corresponding element in the second argument of <*>.
-- 5. Define a function bbmax, together with its signature, which returns the maximum element stored in the
--    BBtree, if present, or Nothing if the data structure is empty.

data BBtree a = BBnil | BBtree (BBtree a) a a (BBtree a)
  deriving (Eq, Show)

-- Helper: convert to list for canonical operations
bb2list BBnil = []
bb2list (BBtree l x y r) = bb2list l ++ [x, y] ++ bb2list r

-- FUNCTOR: apply f to both values in each node
instance Functor BBtree where
  fmap _ BBnil = BBnil
  fmap f (BBtree l x y r) = BBtree (fmap f l) (f x) (f y) (fmap f r)

-- FOLDABLE: in-order traversal
instance Foldable BBtree where
  foldr _ z BBnil = z
  foldr f z (BBtree l x y r) = foldr f (f x (f y (foldr f z r))) l

-- APPLICATIVE: zip-like (shapes must match!)
instance Applicative BBtree where
  pure x = BBtree BBnil x x BBnil
  BBnil <*> _ = BBnil
  _ <*> BBnil = BBnil
  (BBtree lf f1 f2 rf) <*> (BBtree lx x1 x2 rx) =
    BBtree (lf <*> lx) (f1 x1) (f2 x2) (rf <*> rx)

-- Finding maximum using Foldable's derived function
bbmax BBnil = Nothing
bbmax t = Just (maximum t)