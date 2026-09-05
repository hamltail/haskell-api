{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import qualified Data.Text.Lazy as TL
import Web.Scotty

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

        Left err ->
          text ("Failed to load posts.json: " <> TL.pack err)
