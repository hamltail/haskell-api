aaa :: IO ()
aaa = putStrLn "Hello, Haskell!"

name :: String
name = "hamru"

age :: Int
age = 99

double :: Int -> Int
double x = x * 2

main :: IO ()
main = do
  aaa
  putStrLn ("name   = " ++ name)
  putStrLn ("age    = " ++ show age)
  putStrLn ("double = " ++ show (double age))
