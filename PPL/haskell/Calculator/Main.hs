module Main where 

import Calculator (loop)

main :: IO()
main = do
    putStrLn "Welcome to the Haskell Calculator!"
    Calculator.loop []