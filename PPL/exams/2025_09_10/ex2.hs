-- Define a data-type called QTT (for Quaternary-Ternary Trees), where nodes can be either ternary or quaternary,
-- and each node contains a value. The empty tree Nil is also allowed. Note: there must not be unary or binary
-- nodes.
-- 1. Make QTT an instance of Functor and Foldable.
-- 2. Define a binary merge operation for QTT, with the following constraints:
-- • If one of the operands is a ternary node, it must become quaternary, and the other operand will
--   become the fourth child.
-- • If both operands are quaternary nodes, then the right operand must be merged into the rightmost
--   child of the left operand (recursively).
-- 3. Make QTT an instance of Applicative..
{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}

data QTT a = Nil | Ternary a (QTT a) (QTT a) (QTT a) | Quaternary a (QTT a) (QTT a) (QTT a) (QTT a)
  deriving (Show, Eq)

instance Foldable QTT where
  foldr _ initial Nil = initial
  foldr f initial (Ternary x l m r) =
    f x (foldr f (foldr f (foldr f initial r) m) l)
  foldr f initial (Quaternary x a b c d) =
    f x (foldr f (foldr f (foldr f (foldr f initial d) c) b) a)

instance Functor QTT where
    fmap _ Nil = Nil
    fmap f (Ternary node l c r) = Ternary (f node) (fmap f l) (fmap f c) (fmap f r)
    fmap f (Quaternary node l cl cr r) = Quaternary (f node) (fmap f l) (fmap f cl) (fmap f cr) (fmap f r)

merge Nil t = t
merge t Nil = t
merge t (Ternary node l c r) = Quaternary node l c r t
merge (Ternary node l c r) t = Quaternary node l c r t
merge (Quaternary node l cl cr r) t = Quaternary node l cl cr (merge r t)

tconcat tree = foldr merge Nil tree

tconcmap func tree = tconcat (fmap func tree)

instance Applicative QTT where
    pure x = Ternary x Nil Nil Nil
    fs <*> xs = tconcmap (\f -> fmap f xs) fs