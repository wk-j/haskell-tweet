module Lib ( tweet) where

import System.Environment (getArgs)
import Network.Curl.Download (openURIString)
import Data.List.Split (splitOn)
import System.Process (callCommand)
import System.Directory
import Data.Time (getCurrentTime, getZonedTime)
import Text.Printf (printf)
import Prelude hiding (readFile)
import System.IO.Strict (readFile)

getReadmeContent :: String -> IO [String]
getReadmeContent file = do
    contents <- readFile file
    return $ lines contents
    
saveReadmeContent file contents = do
    writeFile file $ unlines contents

insertAt :: a -> [a] -> Int -> [a]
insertAt x ys 1 = x : ys
insertAt x (y:ys) n = y : insertAt x ys (n - 1)

formatMark title url = do

    let sp1 =  (!! 3) . splitOn  "/"
    let at = sp1 url

    let sp2 =  (!! 0) . splitOn  "/status/"
    let atLink = sp2 url

    zonedTime <- fmap show getZonedTime
    return $ printf "- `[%s]` [@%s](%s) ~ [%s](%s)" (take 16 zonedTime) at atLink title url
    -- return $ printf "- `[%s]` [%s](%s)" at title url
  
processMark file title url = do
    lines <- getReadmeContent file
    format <- formatMark title url
    let newLines  = insertAt format lines 3
    
    saveReadmeContent file newLines

    putStrLn $ printf " -- %s" title
    putStrLn $ printf " -- %s" url
    
commit :: String -> String -> IO()
commit markRoot mark = do

    let addCmd = printf "git -C %s add --all" markRoot
    let commitCmd = printf "git -C %s commit -m \"%s\"" markRoot mark
    let pushCmd = printf "git -C %s push -u github master" markRoot
    
    callCommand addCmd
    callCommand commitCmd
    callCommand pushCmd

startTweet title link = do
    root <- getHomeDirectory
    let markRoot = root ++ "/.tweets"
    let readme = markRoot ++ "/README.md"

    processMark readme title link
    commit markRoot title

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
                    startTweet title link
        _ -> do
            putStrLn "-- invalid arguments"
