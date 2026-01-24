{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (14 pts)
-- A deque, short for double-ended queue, is a list-like data structure that supports efficient element
-- insertion and removal from both its head and its tail. Recall that Haskell lists, however, only support O(1)
-- insertion and removal from their head.
-- Implement a deque data type in Haskell by using two lists: the first one containing elements from the
-- initial part of the list, and the second one containing elements form the final part of the list, reversed.
-- In this way, elements can be inserted/removed from the first list when pushing to/popping the deque's
-- head, and from the second list when pushing to/popping the deque's tail.
-- 1) Write a data type declaration for Deque.
-- 2) Implement the following functions:
-- • toList: takes a Deque and converts it to a list
-- • fromList: takes a list and converts it to a Deque
-- • pushFront: pushes a new element to a Deque's head
-- • popFront: pops the first element of a Deque, returning a tuple with the popped element and the
--             new Deque
-- • pushBack: pushes a new element to the end of a Deque
-- • popBack: pops the last element of a Deque, returning a tuple with the popped element and the new
-- Deque
-- 3) Make Deque an instance of Eq and Show.
-- 4) Make Deque an instance of Functor, Foldable, Applicative and Monad.
-- You may rely on instances of the above classes for plain lists.

data Deque a = Deque [a] [a]

toList (Deque front back) = front ++ reverse back

fromList list = Deque front (reverse back)
  where
    half = length list `div` 2
    (front, back) = splitAt half list


instance (Eq a) => Eq (Deque a) where
  d1 == d2 = toList d1 == toList d2

instance (Show a) => Show (Deque a) where
  show d = "Deque " ++ show (toList d)


pushFront x (Deque front back) = Deque (x : front) back


popFront (Deque (x : xs) back) = (x, Deque xs back)
popFront (Deque [] []) = error "popFront: Empty Deque"
popFront (Deque [] back) = popFront (fromList (reverse back))

pushBack x (Deque front back) = Deque front (x : back)


popBack (Deque front (x : xs)) = (x, Deque front xs)
popBack (Deque [] []) = error "popBack: Empty Deque"
popBack (Deque front []) = popBack (fromList front)

instance Functor Deque where
  fmap f (Deque front back) = Deque (map f front) (map f back)

instance Foldable Deque where
  foldr f acc d = foldr f acc (toList d)

instance Applicative Deque where
  pure x = Deque [x] []
  df <*> dx = fromList (toList df <*> toList dx)

instance Monad Deque where
  d >>= f = fromList (toList d >>= (toList . f))