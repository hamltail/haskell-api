-- data 型名 = データコンストラクタ
-- 左の User は「型の名前」、右の User は「値を作るための名前」
-- それぞれ別名にもできるが、単純な型では同じ名前にすることが多い
--
-- data User = CreateUser と書くこともできる
--      ↑          ↑
--    型の名前    値を作る名前
data User = User
  { name :: String,
    age :: Int
  }
  deriving (Show)

hamru :: User
hamru =
  User
    { name = "hamru",
      age = 99
    }

felina :: User
felina =
  User
    { name = "felina",
      age = 3
    }

users :: [User]
users = [hamru, felina]

introduce :: User -> String
introduce user =
  name user ++ " is " ++ show (age user) ++ " years old."

-- User をパターンマッチで分解する
-- userName / userAge は任意の変数名で、フィールドの「位置」に対応する
introducePattern :: User -> String
introducePattern (User userName userAge) =
  userName ++ " is " ++ show userAge ++ " years old."

main :: IO ()
main = do
  print hamru
  print (name hamru)
  print (age hamru)

  print users
  print (map name users)

  print (introduce hamru)
  print (introduce felina)

  print (introducePattern hamru)
  print (introducePattern felina)
