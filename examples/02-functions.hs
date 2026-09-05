-- 引数1個
double :: Int -> Int
double x = x * 2

-- 引数2個
add :: Int -> Int -> Int
add x y = x + y

-- 関数を組み合わせる
doubleAndAdd :: Int -> Int -> Int
doubleAndAdd x y = double x + y

square :: Int -> Int
square x = x * x

main :: IO ()
main = do
  print (double 5)
  print (add 5 3)
  print (doubleAndAdd 5 3)
  print (square 5)
