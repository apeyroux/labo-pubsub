{-# LANGUAGE OverloadedStrings #-}

import PubSub.Worker

main :: IO ()
main = do
  putStrLn "starting ..."
  startWorker

