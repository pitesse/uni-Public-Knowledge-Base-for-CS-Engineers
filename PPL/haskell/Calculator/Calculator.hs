module Calculator where
import Text.Read (readMaybe)

data Input
  = Num (Maybe Double)
    | Op (Double -> Double -> Double)
    | Compute -- user pressed '='
    | Exit -- user wants to exit

parse :: String -> Input
parse "+" = Op (+)
parse "-" = Op (-)
parse "*" = Op (*)
parse "/" = Op (/)
parse "=" = Compute
parse "exit" = Exit
parse x = Num (readMaybe x :: Maybe Double)

compute :: [Input] -> Double
compute [] = 0
compute [Num (Just x)] = x
compute ((Num (Just x)) : (Op f) : (Num (Just y)) : xs) = compute $ Num (Just $ f x y) : xs
compute _ = error "invalid input"


loop :: [Input] -> IO ()
loop ops = do

  input <- getLine
  putStrLn $ "You entered: " ++ input

  let x = parse input

  case x of
    Compute -> putStrLn $ "Result is: " ++ show (compute ops)
    Exit -> putStrLn "Exiting calculator. Goodbye!"
    _ -> loop $ ops ++ [x]
  putStrLn ""
