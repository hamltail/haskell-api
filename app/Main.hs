{-# LANGUAGE OverloadedStrings #-}

import App (routes)
import Data.Aeson
import System.Environment (getEnv)
import Web.Scotty

main :: IO ()
main = do
  apiName <- getEnv "API_NAME"
  apiLanguage <- getEnv "API_LANGUAGE"
  apiCategory <- getEnv "API_CATEGORY"
  apiKey <- getEnv "API_KEY"
  postsResult <- eitherDecodeFileStrict "data/posts.json" :: IO (Either String [Value])

  scotty 3000 $
    routes apiName apiLanguage apiCategory apiKey postsResult
