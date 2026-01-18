-- HASKELL
-- Exercise 2, Haskell (11 pts)
-- Define a data-type called BTT which implements trees that can be binary or ternary, and where every
-- node contains a value, but the empty tree (Nil). Note: there must not be unary nodes, like leaves.
-- 1) Make BTT an instance of Functor and Foldable.
-- 2) Define a concatenation for BTT, with the following constraints:
-- • If one of the operands is a binary node, such node must become ternary, and the other operand
--   will become the added subtree (e.g. if the binary node is the left operand, the rightmost node of
--   the new ternary node will be the right operand).
-- • If both the operands are ternary nodes, the right operand must be appened on the right of the left
--   operand, by recursively calling concatenation.
-- 3) Make BTT an instance of Applicative.
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Eta reduce" -}

data BTT a
  = Nil
  | Binary a (BTT a) (BTT a)
  | Ternary a (BTT a) (BTT a) (BTT a)
  deriving(Show, Eq)

instance Functor BTT where
  fmap _ Nil = Nil
  fmap f (Binary x l r) =
    Binary (f x) (fmap f l) (fmap f r)
  fmap f (Ternary x l m r) =
    Ternary (f x) (fmap f l) (fmap f m) (fmap f r)

instance Foldable BTT where
  foldr _ z Nil = z
  foldr f z (Binary x l r) =
    f x (foldr f (foldr f z r) l)
  foldr f z (Ternary x l m r) =
    f x (foldr f (foldr f (foldr f z r) m) l)

merge Nil t = t
merge t Nil = t
merge (Binary n l r) t = Ternary n l r t
merge t (Binary n l r) = Ternary n t l r
merge (Ternary n l m r) t2@(Ternary n' l' m' r') = Ternary n l m (merge r t2) 

tconcat tree = foldr merge Nil tree

tconcmap f t = tconcat (fmap f t)

instance Applicative BTT where
  pure x = Binary x Nil Nil
  fs <*> xs = tconcmap (\f -> fmap f xs) fs

