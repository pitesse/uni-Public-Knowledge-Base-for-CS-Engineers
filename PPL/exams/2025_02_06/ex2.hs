{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}

-- Exercise 2, Haskell (11 pts)
-- A simply-linked circular list (called Clist from now on) is a list in which the last node points to the first node. It is
-- sometimes useful to have a “sentinel” last node, i.e. a node that does not contain data. The sentinel is used e.g. to
-- check if we have traversed the whole list. An empty list contains only the sentinel node, that points to itself.
-- Consider the following implementation of circular lists:

-- data Clist a = Node a (Clist a) | End (Clist a) -- End is the Sentinel node
-- instance (Show a) => Show (Clist a) where
--  show (End _) = "..."
--  show (Node v next) = show v ++ ", " ++ show next
-- instance (Eq a) => Eq (Clist a) where
--  End _ == End _ = True
--  (Node x next) == (Node x' next') = (x == x') && next == next'
--  _ == _ = False

-- 1) Explain why Clist does not derive Show and Eq in its definition.
-- 2) Make Clist an instance of Functor and Applicative. NB: you cannot translate Clist to standard lists and back, in
--    the implementation of the requested methods.

data Clist a = Node a (Clist a) | End (Clist a) -- End is the Sentinel node

instance (Show a) => Show (Clist a) where
  show (End _) = "..."
  show (Node v next) = show v ++ ", " ++ show next

instance (Eq a) => Eq (Clist a) where
  End _ == End _ = True
  (Node x next) == (Node x' next') = (x == x') && next == next'
  _ == _ = False

-- cant derive them cause they will loop through the circle, so we need to define Show and Eq

-- FUNCTOR
instance Functor Clist where
  -- Case 1: The empty list (just a sentinel pointing to itself)
  fmap _ (End _) = let empty = End empty in empty
  -- Case 2: A list with data
  fmap f (Node x next) =
    -- "first" is the handle to the start of our NEW result list
    let first = Node (f x) (go next first)
     in first
    where
      -- 'go' walks down the OLD list, building the NEW list
      -- It carries 'startHandle' to plug into the end.
      go (End _) startHandle = End startHandle
      go (Node v rest) startHandle = Node (f v) (go rest startHandle)

-- APPLICATIVE (Zip-like)
instance Applicative Clist where
  -- pure: A single node circle
  pure x = let first = Node x (End first) in first

  -- (<*>): Zip two circular lists together
  -- Case 1: If either list is just a sentinel (empty), result is empty
  (End _) <*> _ = let e = End e in e
  _ <*> (End _) = let e = End e in e
  -- Case 2: Both have data. Zip them!
  (Node f fs) <*> (Node x xs) =
    let first = Node (f x) (zipGo fs xs first)
     in first
    where
      -- Helper: zips the tails until it hits an End
      zipGo (End _) _ startHandle = End startHandle
      zipGo _ (End _) startHandle = End startHandle
      zipGo (Node f' fs') (Node x' xs') startHandle =
        Node (f' x') (zipGo fs' xs' startHandle)