{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Char8 as C8
import qualified Data.Text.Lazy as TL
import           Database.Redis
import           PubSub.Types
import           PubSub.Worker
import           Web.Scotty

main :: IO ()
main = do

  wid <- startWorker
  rconn <- checkedConnect defaultConnectInfo

  putStrLn $ "starting " <> (show wid) <> " ..."

  scotty 3000 $ do

    post "/" $ do
      uuids <- param "uids"
      _ <- liftAndCatchIO $ runRedis rconn $ publish "actions" (C8.pack $ uuids)
      html $ "starting new action with " <> (TL.pack $ show uuids) <> " ..."
  
    Web.Scotty.get "/" $ do
      html "form to post /"

  _ <- getLine
  return ()

  where
    uids :: UIds
    uids = ["123456", "654321"]
