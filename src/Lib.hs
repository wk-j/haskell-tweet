module Lib ( tweet) where

import System.Environment (getArgs)
import Network.Curl.Download

tweet :: IO ()
tweet = do  
    args <- getArgs

    case args of 
        [link] -> do
            content <- openURIString link
            putStrLn link
            case content of
                Left  err -> putStrLn "-- error"
                Right text -> putStrLn text
        _ -> do
            putStrLn "-- invalid arguments"
