{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module PubSub.Worker (startWorker) where

import Control.Concurrent
import Control.Exception
import Control.Monad
import Data.ByteString.Char8
import Database.Redis

import Prelude hiding (putStrLn)

myhandler :: ByteString -> IO ()
myhandler msg = putStrLn $ msg

onInitialComplete :: IO ()
onInitialComplete = putStrLn "Redis actions is now subscribed"

startWorker :: IO ThreadId
startWorker = do
  putStrLn "Start worker ..."
  conn <- connect defaultConnectInfo
  pubSubCtrl <- newPubSubController [("actions", myhandler)] []
  forkIO $ forever $
      pubSubForever conn pubSubCtrl onInitialComplete
        `catch` (\(e :: SomeException) -> do
          putStrLn $ pack $ "Got error: " ++ show e
          threadDelay $ 50*1000) -- TODO: use exponential backoff
