module Lib ( tweet) where

import System.Environment (getArgs)
import Network.Curl.Download
import Data.List.Split

start :: String -> String -> IO()
start title link = do
    let sp =  (!! 3) . splitOn  "/"
    let at = sp link
    putStrLn at

tweet :: IO ()
tweet = do  
    args <- getArgs

    case args of 
        [title, link] -> do
            content <- openURIString link
            putStrLn link
            case content of
                Left  err -> putStrLn $ "-- error " ++ err
                Right text ->
                    start title link
        _ -> do
            putStrLn "-- invalid arguments"
