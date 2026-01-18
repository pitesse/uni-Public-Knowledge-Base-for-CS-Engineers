-- HASKELL
import Prelude hiding (lookup)

-- HASKELL
-- Ex 2
-- HASKELL:
-- A multi-valued map (Multimap) is a data structure that associates keys of
-- a type k to zero or more values of type v.  A Multimap can be represented as
-- a list of 'Multinodes', as defined below. Each multinode contains a unique key
-- and a non-empty list of values associated to it.

-- data Multinode k v = Multinode { key :: k
--                                , values :: [v]
--                                }

-- data Multimap k v = Multimap [Multinode k v]

-- 1) Implement the following functions that manipulate a Multimap:

-- insert :: Eq k => k -> v -> Multimap k v -> Multimap k v
-- insert key val m returns a new Multimap identical to m, except val is added to the values associated to k.

-- lookup :: Eq k => k -> Multimap k v -> [v]
-- lookup key m returns the list of values associated to key in m

-- remove :: Eq v => v -> Multimap k v -> Multimap k v
-- remove val m returns a new Multimap identical to m, but without all values equal to val

-- 2) Make Multimap k an instance of Functor.
{- HLINT ignore "Use newtype instead of data" -}
data Multinode k v = Multinode
  { key :: k,
    values :: [v]
  }

data Multimap k v = Multimap [Multinode k v]

insert :: (Eq k) => k -> v -> Multimap k v -> Multimap k v
insert newKey newVal (Multimap nodes) = Multimap (updateNodes nodes)
  where
    updateNodes [] = [Multinode newKey [newVal]]
    updateNodes (node@(Multinode key values) : rest)
      | key == newKey = Multinode key (newVal : values) : rest
      | otherwise     = node : updateNodes rest

lookup :: (Eq k) => k -> Multimap k v -> [v]
lookup _ (Multimap []) = []
lookup searchKey (Multimap ((Multinode currentKey currentValues) : remainingNodes))
  | currentKey == searchKey = currentValues
  | otherwise = lookup searchKey (Multimap remainingNodes)

remove :: (Eq v) => v -> Multimap k v -> Multimap k v
remove valueToRemove (Multimap nodes) = Multimap (foldr filterValues [] nodes)
  where
    filterValues (Multinode currentKey currentValues) filteredNodes =
      let updatedValues = filter (/= valueToRemove) currentValues
       in if null updatedValues
            then filteredNodes
            else Multinode currentKey updatedValues : filteredNodes

instance Functor (Multimap k) where
  fmap f (Multimap nodes) = Multimap (map updateValues nodes)
    where
      updateValues (Multinode key vals) = Multinode key (map f vals)