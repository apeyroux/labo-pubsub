{-# LANGUAGE OverloadedStrings #-}

import PubSub.Worker

main :: IO ()
main = do
  wid <- startWorker
  putStrLn $ "starting " <> (show wid) <> " ..."
  _ <- getLine
  return ()
