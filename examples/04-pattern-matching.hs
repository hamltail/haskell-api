describe :: Int -> String
-- 値のパターンに応じて処理を分ける
-- _ はワイルドカードで、0 / 1 以外のすべてにマッチする
describe 0 = "zero"
describe 1 = "one"
describe _ = "other"

first :: [Int] -> String
first [] = "empty"
-- (x : _) はリストを「先頭」と「残り」に分解する
-- x は先頭要素、_ は残りの要素（今回は使わないので捨てる）
-- [10, 20, 30] -> x = 10, _ = [20, 30]
first (x : _) = show x

split :: [Int] -> String
split [] = "empty"
split (x : xs) = "first = " ++ show x ++ ", rest = " ++ show xs

{- HLINT ignore sumList "Use foldr" -}

sumList :: [Int] -> Int
-- 空リストになったら再帰を終了して 0 を返す
sumList [] = 0
-- (x : xs) でリストを「先頭 x」と「残り xs」に分解する
-- 先頭 x を足し、残り xs をもう一度 sumList に渡す
--
-- sumList [10, 20, 30]
-- -> 10 + sumList [20, 30]
-- -> 10 + 20 + sumList [30]
-- -> 10 + 20 + 30 + sumList []
-- -> 10 + 20 + 30 + 0
-- -> 60
sumList (x : xs) = x + sumList xs

countList :: [Int] -> Int
countList [] = 0
countList (_ : xs) = 1 + countList xs

main :: IO ()
main = do
  print (describe 0)
  print (describe 1)
  print (describe 99)

  print (first [])
  print (first [10, 20, 30])

  print (split [])
  print (split [10, 20, 30])

  print (sumList [])
  print (sumList [1, 2, 3, 4, 5])

  print (countList [])
  print (countList [10, 20, 30])
