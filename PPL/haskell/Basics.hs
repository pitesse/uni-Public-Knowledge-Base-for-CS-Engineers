-- In Haskell, we write our code in modules
-- The entry point of a program is the 'Main'
-- module, with a function called 'main'
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Basics where

-- this is a variable assignment
-- in ghci you can load the module and query the value of 'hello'
hello = "Hello!"
-- ATTENTION: variables in Haskell are immutable.
{-- 
example: this code works. It also doesn't matter the order which variables are defined in.
y = x + 1
x = 2
--}

-- optionally, we can declare the type of a function
-- usage: greet "World" => "Hello World!"
greet :: String -> String
greet name = "Hello " ++ name ++ "!"

-- multiple arguments are possible
-- usage: greetFull "John" "Doe" => "Hello John Doe!"
greetFull :: String -> (String -> String) -- parenthesis are optinional but help to understand 
greetFull first last = "Hello " ++ first ++ " " ++ last ++ "!"

-- we can also create 'partially applied functions'
-- usage: partialGreet "Doe" => "Hello John Doe!"
partialGreet = greetFull "John"

-- = is not assignment, but DEFINITION
y = x + 1
x = 2

-- we can have 'TYPE variables', aka placeholders
-- for any type in our function: '[a]' can be a list of any type
-- Also, functions are defined through PATTERN MATCHING
howLong :: [a] -> Integer
howLong [] = 0                      -- match base case: empty list => 0
howLong (_ : xs) = 1 + howLong xs   -- match recursive case
-- here, '_' is the 'car', and 'xs' is the 'cdr'
-- this is VERY handy!