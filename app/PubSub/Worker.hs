{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module PubSub.Worker (startWorker) where

import Control.Concurrent
import Control.Exception
import Control.Monad
import PubSub.Types
import Data.ByteString.Char8
import Database.Redis

import Prelude hiding (putStrLn)

actionHandler :: ByteString -> IO ()
actionHandler msg = return (read $ unpack msg::UIds) >>= mapM_ (\uid -> putStrLn $ pack $ "- Processing of " <> uid)

onInitialComplete :: IO ()
onInitialComplete = putStrLn "Redis actions is now subscribed"

startWorker :: IO ThreadId
startWorker = do
  putStrLn "Start worker ..."
  conn <- connect defaultConnectInfo
  pubSubCtrl <- newPubSubController [("actions", actionHandler)] []
  forkIO $ forever $
      pubSubForever conn pubSubCtrl onInitialComplete
        `catch` (\(e :: SomeException) -> do
          putStrLn $ pack $ "Got error: " ++ show e
          threadDelay $ 50*1000)
