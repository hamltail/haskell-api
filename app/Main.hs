{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import qualified Data.Aeson.KeyMap as KM
import Data.List (find)
import Data.Scientific (toBoundedInteger)
import Data.Text (Text)
import qualified Data.Text.Lazy as TL
import Network.HTTP.Types.Status (internalServerError500, notFound404, unauthorized401)
import System.Environment (getEnv)
import Web.Scotty
-- import Control.Monad.IO.Class (liftIO)

findPost :: Int -> [Value] -> Maybe Value
findPost postId = find matchesPost
  where
    matchesPost (Object postObject) =
      case KM.lookup "id" postObject of
        Just (Number value) -> toBoundedInteger value == Just postId
        _ -> False
    matchesPost _ = False

filterPostsByUsername :: Text -> [Value] -> [Value]
filterPostsByUsername username = filter matchesUsername
  where
    matchesUsername (Object postObject) =
      case KM.lookup "user" postObject of
        Just (Object userObject) ->
          case KM.lookup "username" userObject of
            Just (String value) -> value == username
            _ -> False
        _ -> False
    matchesUsername _ = False

requireApiKey :: String -> ActionM ()
requireApiKey expectedApiKey = do
  actualApiKey <- header "X-API-Key"
  -- liftIO $ print actualApiKey
  -- liftIO $ print expectedApiKey
  case actualApiKey of
    Just value
      | TL.unpack value == expectedApiKey -> pure ()
    _ -> do
      status unauthorized401
      json $
        object
          [ "error"
              .= object
                [ "code" .= ("UNAUTHORIZED" :: String),
                  "message" .= ("Invalid API key" :: String)
                ]
          ]
      finish

main :: IO ()
main = do
  apiName <- getEnv "API_NAME"
  apiLanguage <- getEnv "API_LANGUAGE"
  apiCategory <- getEnv "API_CATEGORY"
  apiKey <- getEnv "API_KEY"
  postsResult <- eitherDecodeFileStrict "data/posts.json" :: IO (Either String [Value])

  scotty 3000 $ do
    get "/health" $ do
      text "OK"

    get "/api/v1/posts" $ do
      requireApiKey apiKey
      username <- queryParamMaybe "username"
      case postsResult of
        Right posts -> do
          let filteredPosts =
                case username of
                  Just value -> filterPostsByUsername value posts
                  Nothing -> posts
          json $
            object
              [ "meta"
                  .= object
                    [ "api"
                        .= object
                          [ "name" .= apiName,
                            "language" .= apiLanguage,
                            "category" .= apiCategory
                          ],
                      "count" .= length filteredPosts
                    ],
                "data"
                  .= object
                    [ "posts" .= filteredPosts
                    ]
              ]
        Left err -> do
          status internalServerError500
          text ("Failed to load posts.json: " <> TL.pack err)

    get "/api/v1/posts/:id" $ do
      requireApiKey apiKey
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
                              [ "name" .= apiName,
                                "language" .= apiLanguage,
                                "category" .= apiCategory
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
