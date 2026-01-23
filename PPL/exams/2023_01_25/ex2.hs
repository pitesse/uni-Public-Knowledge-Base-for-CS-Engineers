{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Avoid lambda using `infix`" -}
{- HLINT ignore "Fuse foldr/fmap" -}
{- HLINT ignore "Use newtype instead of data" -}
{- HLINT ignore "Redundant bracket" -}

-- Exercise 2, Haskell (11 pts)
-- We want to define a data structure for the tape of a Turing machine: Tape is a parametric data structure with
-- respect to the tape content, and must be made of three components:
-- 1. the portion of the tape that is on the left of the head;
-- 2. the symbol on which the head is positioned;
-- 3. the portion of the tape that is on the right of the head.
-- Also, consider that the machine has a concept of "blank" symbols, so you need to add another component in the
-- data definition to store the symbol used to represent the blank in the parameter type.
-- 1. Define Tape.
-- 2. Make Tape an instance of Show and Eq, considering that two tapes contain the same values if their stored
--    values are the same and in the same order, regardless of the position of their heads.
-- 3. Define the two functions left and right, to move the position of the head on the left and on the right.
-- 4. Make Tape an instance of Functor and Applicative.

data Tape a = Tape [a] a [a] a


-- Move Left: head of Left becomes Focus, old Focus pushed to Right
left (Tape [] c y b) = Tape [] b (c : y) b -- hit edge: use blank
left (Tape (x : xs) c y b) = Tape xs x (c : y) b -- normal move

-- Move Right: head of Right becomes Focus, old Focus pushed to Left
right (Tape x c [] b) = Tape (c : x) b [] b -- hit edge: use blank
right (Tape x c (y : ys) b) = Tape (c : x) y ys b -- normal move

-- Write at current position
write v (Tape l _ r b) = Tape l v r b

-- FUNCTOR: Apply f to all cells including blank
instance Functor Tape where
  fmap f (Tape l c r b) = Tape (map f l) (f c) (map f r) (f b)

-- FOLDABLE: Traverse left (reversed), focus, then right
instance Foldable Tape where
  foldr f z (Tape l c r _) =
    foldr f (f c (foldr f z r)) (reverse l)

-- APPLICATIVE: Zip-like (apply function at each position)
instance Applicative Tape where
  pure x = Tape (repeat x) x (repeat x) x -- infinite tape of x
  (Tape lf cf rf bf) <*> (Tape lx cx rx bx) =
    Tape
      (zipWith ($) lf lx) -- apply pairwise
      (cf cx) -- apply at focus
      (zipWith ($) rf rx)
      (bf bx)