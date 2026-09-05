{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import qualified Data.Aeson.KeyMap as KM
import Data.List (find)
import Data.Scientific (toBoundedInteger)
import qualified Data.Text.Lazy as TL
import Network.HTTP.Types.Status (internalServerError500, notFound404)
import Web.Scotty

findPost :: Int -> [Value] -> Maybe Value
findPost postId = find matchesPost
  where
    matchesPost (Object postObject) =
      case KM.lookup "id" postObject of
        Just (Number value) -> toBoundedInteger value == Just postId
        _ -> False
    matchesPost _ = False

main :: IO ()
main = do
  postsResult <- eitherDecodeFileStrict "data/posts.json" :: IO (Either String [Value])

  scotty 3000 $ do
    get "/health" $ do
      text "OK"

    get "/api/v1/posts" $ do
      case postsResult of
        Right posts ->
          json $
            object
              [ "meta"
                  .= object
                    [ "api"
                        .= object
                          [ "name" .= ("haskell-api" :: String),
                            "language" .= ("Haskell" :: String),
                            "category" .= ("public" :: String)
                          ],
                      "count" .= length posts
                    ],
                "data"
                  .= object
                    [ "posts" .= posts
                    ]
              ]
        Left err -> do
          status internalServerError500
          text ("Failed to load posts.json: " <> TL.pack err)

    get "/api/v1/posts/:id" $ do
      postId <- pathParam "id"
      case postsResult of
        Right posts ->
          case findPost postId posts of
            Just postValue ->
              json $
                object
                  [ "meta"
                      .= object
                        [ "api"
                            .= object
                              [ "name" .= ("haskell-api" :: String),
                                "language" .= ("Haskell" :: String),
                                "category" .= ("public" :: String)
                              ]
                        ],
                    "data"
                      .= object
                        [ "post" .= postValue
                        ]
                  ]
            Nothing -> do
              status notFound404
              json $
                object
                  [ "error"
                      .= object
                        [ "code" .= ("NOT_FOUND" :: String),
                          "message" .= ("Post not found" :: String)
                        ]
                  ]
        Left err -> do
          status internalServerError500
          text ("Failed to load posts.json: " <> TL.pack err)
