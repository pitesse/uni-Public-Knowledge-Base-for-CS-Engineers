{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}

-- Consider the following type of expressions, containing variables of some type a, constants that are integers, and a
-- kind of binary operator called Op.
-- data Expr a = Var a | Const Int | Op (Expr a) (Expr a)
-- 1) Make it an instance of Functor, Applicative, and Monad.
-- 2) Using an example, show what the >>= operator does in your implementation.

data Expr a = Var a | Const Int | Op (Expr a) (Expr a)

instance Functor Expr where
  fmap _ (Const a) = (Const a)
  fmap f (Var a) = Var (f a)
  fmap f (Op x y) = Op (fmap f x) (fmap f y)

instance Applicative Expr where
  pure x = Var x
  (<*>) :: Expr (a -> b) -> Expr a -> Expr b
  _ <*> Const x = Const x
  Const x <*> _ = Const x
  Var f <*> Var v = Var (f v)
  Var f <*> Op v1 v2 = Op (fmap f v1) (fmap f v2)
  Op f g <*> x = Op (f <*> x) (g <*> x)

instance Monad Expr where
  Const x >>= _ = Const x
  Var x >>= f = f x
  Op a b >>= f = Op (a >>= f) (b >>= f)

-- Example:
-- Var 3 >>= \x -> Var (x*2)
-- result: Var 6
-- Op (Var 1) (Var 2) >>= \x -> Var (x + 1)
-- result: Op (Var 2) (Var 3)
