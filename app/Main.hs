{-# LANGUAGE OverloadedStrings #-}

import App (routes)
import Data.Aeson
import System.Environment (getEnv, lookupEnv)
import Text.Read (readMaybe)
import Web.Scotty

main :: IO ()
main = do
  apiName <- getEnv "API_NAME"
  apiLanguage <- getEnv "API_LANGUAGE"
  apiCategory <- getEnv "API_CATEGORY"
  apiKey <- getEnv "API_KEY"
  port <- getPort
  postsResult <- eitherDecodeFileStrict "data/posts.json" :: IO (Either String [Value])

  scotty port $
    routes apiName apiLanguage apiCategory apiKey postsResult

getPort :: IO Int
getPort = do
  portValue <- lookupEnv "PORT"
  pure $
    case portValue >>= readMaybe of
      Just port -> port
      Nothing -> 3000
