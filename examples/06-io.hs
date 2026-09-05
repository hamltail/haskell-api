import Text.Read (readMaybe)

greet :: String -> String
greet userName = "Hello, " ++ userName ++ "!"

main :: IO ()
main = do
  putStrLn "What is your name?"

  -- <- : IO処理から得られた値を受け取る
  -- getLine :: IO String
  userName <- getLine

  putStrLn (greet userName)

  putStrLn "How old are you?"
  ageText <- getLine

  -- readMaybe: String を安全に変換する
  -- 成功すると Just 値、失敗すると Nothing を返す
  case readMaybe ageText :: Maybe Int of
    Just age -> do
      print age
      print (age + 1)
    Nothing ->
      putStrLn "Please enter a number."
