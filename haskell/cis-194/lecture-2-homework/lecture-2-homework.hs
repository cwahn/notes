module LogAnalysis where

import Distribution.PackageDescription (mapTreeConds)
import Distribution.Simple.Utils (dropWhileEndLE)
import GHC.RTS.Flags (TraceFlags (timestamp))
import GHC.Utils.Encoding (toBase62)
import Log
import Log (LogMessage (Unknown), MessageTree (Leaf))
import Text.Parsec.Error (Message (Message))
import Text.Read (readMaybe)

-- Exercise 1 The first step is figuring out how to parse an individual message. Define a function
-- parseMessage "E 2 562 help help"
--      == LogMessage (Error 2) 562 "help help"
--  parseMessage "I 29 la la la"
--      == LogMessage Info 29 "la la la"
--  parseMessage "This is not in the right format"
--      == Unknown "This is not in the right format"

parseMessageType :: String -> (Maybe MessageType, String)
parseMessageType msg = case words msg of
  [] -> (Nothing, msg)
  (x : xs) -> case x of
    "I" -> (Just Info, unwords xs)
    "W" -> (Just Warning, unwords xs)
    "E" -> case xs of
      [] -> (Nothing, msg)
      (y : ys) -> case readMaybe y of
        Nothing -> (Nothing, msg)
        Just n -> (Just (Error n), unwords ys)
    _ -> (Nothing, msg)

parseTimeStamp :: String -> (Maybe TimeStamp, String)
parseTimeStamp str = case words str of
  [] -> (Nothing, str)
  (x : xs) -> case readMaybe x of
    Nothing -> (Nothing, str)
    Just n -> (Just n, unwords xs)

parseMessage :: String -> LogMessage
parseMessage str = case parseMessageType str of
  (Nothing, str) -> Unknown str
  (Just msgType, str) -> case parseTimeStamp str of
    (Nothing, str) -> Unknown str
    (Just timeStamp, str) -> LogMessage msgType timeStamp str

parse :: String -> [LogMessage]
parse str = map parseMessage (lines str)

-- Exercise 2 Define a function
-- insert :: LogMessage -> MessageTree -> MessageTree
-- which inserts a new LogMessage into an existing MessageTree, pro- ducing a new MessageTree. insert may assume that it is given a sorted MessageTree, and must produce a new sorted MessageTree containing the new LogMessage in addition to the contents of the original MessageTree.
-- However, note that if insert is given a LogMessage which is Unknown, it should return the MessageTree unchanged.

instance Ord LogMessage where
  compare (LogMessage _ ts1 _) (LogMessage _ ts2 _) = compare ts1 ts2

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) mTree = mTree
insert msg Leaf = Node Leaf msg Leaf
insert msg (Node lTree msgRef rTree)
  | msg <= msgRef = Node (insert msg lTree) msgRef rTree
  | msg > msgRef = Node lTree msgRef (insert msg rTree)

-- Exercise 3 Once we can insert a single LogMessage into a MessageTree, we can build a complete MessageTree from a list of messages. Specifi- cally, define a function
--  build :: [LogMessage] -> MessageTree
-- which builds up a MessageTree containing the messages in the list, by successively inserting the messages into a MessageTree (beginning with a Leaf).

build :: [LogMessage] -> MessageTree
build [] = Leaf
build (x : xs) = insert x (build xs)

-- Exercise 4 Finally, define the function inOrder :: MessageTree -> [LogMessage]
-- which takes a sorted MessageTree and produces a list of all the LogMessages it contains, sorted by timestamp from smallest to biggest. (This is known as an in-order traversal of the MessageTree.)
-- With these functions, we can now remove Unknown messages and sort the well-formed messages using an expression such as:
--  inOrder (build tree)
-- [Note: there are much better ways to sort a list; this is just an exer- cise to get you working with recursive data structures!]

inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node lTree ref rTree) = inOrder lTree ++ [ref] ++ inOrder rTree

-- Exercise 5 Now that we can sort the log messages, the only thing left to do is extract the relevant information. We have decided that “relevant” means “errors with a severity of at least 50”.
-- Write a function
-- cis 194: homework 2 4
-- whatWentWrong :: [LogMessage] -> [String]
-- which takes an unsorted list of LogMessages, and returns a list of the messages corresponding to any errors with a severity of 50 or greater, sorted by timestamp. (Of course, you can use your functions from the previous exercises to do the sorting.)
-- For example, suppose our log file looked like this:
--  I 6 Completed armadillo processing
--  I 1 Nothing to report
--  E 99 10 Flange failed!
--  I 4 Everything normal
--  I 11 Initiating self-destruct sequence
--  E 70 3 Way too many pickles
--  E 65 8 Bad pickle-flange interaction detected
--  W 5 Flange is due for a check-up
--  I 7 Out for lunch, back in two time steps
--  E 20 2 Too many pickles
--  I 9 Back from lunch
-- This file is provided as sample.log. There are four errors, three of which have a severity of greater than 50. The output of whatWentWrong on sample.log ought to be
--  [ "Way too many pickles"
--  , "Bad pickle-flange interaction detected"
--  , "Flange failed!"
--  ]
-- You can test your whatWentWrong function with testWhatWentWrong, which is also provided by the Log module. You should provide testWhatWentWrong with your parse function, your whatWentWrong function, and the name of the log file to parse.

isSevere :: LogMessage -> Bool
isSevere (LogMessage (Error i) ts str) = i >= 50
isSevere _ = False

getString :: LogMessage -> String
getString (LogMessage _ _ str) = str
getString _ = ""

whatWentWrong :: [LogMessage] -> [String]
-- whatWentWrong msgs = map getString (filter isSevere (inOrder (build msgs)))
whatWentWrong msgs = map getString (filter isSevere (inOrder (build msgs)))
