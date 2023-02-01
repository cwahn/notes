module Golf where

-- Exercise 1 Hopscotch
-- Your first task is to write a function
-- cis 194: homework 3 2
-- skips :: [a] -> [[a]]
-- The output of skips is a list of lists. The first list in the output should be the same as the input list. The second list in the output should contain every second element from the input list. . . and the nth list in the output should contain every nth element from the input list.
-- For example:
-- == ["ABCD", "BD", "C", "D"]
-- == ["hello!", "el!", "l!", "l", "o", "!"]
-- == [[1]]
-- skips "ABCD"
-- skips "hello!"
-- skips [1]
-- skips [True,False] == [[True,False], [False]]
-- skips []           == []
-- Note that the output should be the same length as the input.

skips :: [a] -> [[a]]
skips as = [skipN n as | n <- [ 1 .. length as]]

skipN :: Int -> [a] -> [a]
skipN _ [] = []
skipN 0 as = as
skipN n as = drop (n - 1) (take n as) ++ skipN n (drop n as)