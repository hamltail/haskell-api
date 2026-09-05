numbers :: [Int]
numbers = [1, 2, 3, 4, 5]

names :: [String]
names = ["hamru", "felina"]

double :: Int -> Int
double x = x * 2

isEven :: Int -> Bool
-- isEven x = even x
-- （η簡約 / イータ簡約）
isEven = even

isOdd :: Int -> Bool
-- isOdd x = odd x
isOdd = odd

main :: IO ()
main = do
  print names
  print numbers

  -- リストの先頭要素を取得
  print (head numbers)

  -- 先頭要素を除いたリストを取得
  print (tail numbers)

  -- リストの要素数を取得
  print (length numbers)

  -- map: 関数とリストを受け取り、各要素に関数を適用した新しいリストを返す
  -- map :: (a -> b) -> [a] -> [b]
  --        関数         リスト   新しいリスト
  -- map double [1, 2, 3] -> [double 1, double 2, double 3] -> [2, 4, 6]
  print (map double numbers)

  -- filter: 条件を判定する関数とリストを受け取り、Trueになった要素だけを残す
  -- filter :: (a -> Bool) -> [a] -> [a]
  --           判定する関数      リスト   新しいリスト
  -- filter isEven [1, 2, 3, 4, 5] -> [2, 4]
  print (filter isEven numbers)

  print (filter isOdd numbers)
