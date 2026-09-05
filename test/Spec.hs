{-# LANGUAGE OverloadedStrings #-}

import App (routes)
import Data.Aeson
import Network.HTTP.Types (methodGet)
import Test.Hspec
import Test.Hspec.Wai
import Web.Scotty (scottyApp)

main :: IO ()
main =
  hspec $
    with testApp $ do
      describe "GET /api/v1/posts" $ do
        it "APIキーがない場合は401を返す" $ do
          get "/api/v1/posts"
            `shouldRespondWith` 401

        it "正しいAPIキーがある場合は200を返す" $ do
          request
            methodGet
            "/api/v1/posts"
            [("X-API-Key", "test-api-key")]
            ""
            `shouldRespondWith` 200

testApp =
  scottyApp $
    routes
      "haskell-api"
      "Haskell"
      "public"
      "test-api-key"
      (Right testPosts)

testPosts :: [Value]
testPosts =
  [ object
      [ "id" .= (1 :: Int),
        "user"
          .= object
            [ "username" .= ("hamru" :: String),
              "displayName" .= ("はむる" :: String)
            ],
        "content" .= ("test post" :: String)
      ]
  ]
