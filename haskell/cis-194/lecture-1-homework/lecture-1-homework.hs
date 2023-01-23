-- Exercise 1 We need to first find the digits of a number. Define the
-- functions
--  toDigits    :: Integer -> [Integer]
--  toDigitsRev :: Integer -> [Integer]
-- toDigits should convert positive Integers to a list of digits. (For 0 or negative inputs, toDigits should return the empty list.) toDigitsRev should do the same, but with the digits reversed.
-- Example: toDigits 1234 == [1,2,3,4] Example: toDigitsRev 1234 == [4,3,2,1] Example: toDigits 0 == []
-- Example: toDigits (-17) == []

toDigits :: Int -> [Int]
toDigits n
  | n <= 0 = []
  | otherwise = toDigits (n `div` 10) ++ [n `mod` 10]

toDigitsRev :: Int -> [Int]
toDigitsRev n
  | n <= 0 = []
  | otherwise = n `mod` 10 : toDigitsRev (n `div` 10)

-- Exercise 2 Once we have the digits in the proper order, we need to double every other one. Define a function
--  doubleEveryOther :: [Integer] -> [Integer]
-- Remember that doubleEveryOther should double every other num- ber beginning from the right, that is, the second-to-last, fourth-to-last, . . . numbers are doubled.
-- Example: doubleEveryOther [8,7,6,5] == [16,7,12,5] Example: doubleEveryOther [1,2,3] == [1,4,3]

takeLastTwo :: [Int] -> [Int]
takeLastTwo [] = []
takeLastTwo [x, y] = [x, y]
takeLastTwo (x : xs) = takeLastTwo xs

removeLastTwo :: [Int] -> [Int]
removeLastTwo [] = []
removeLastTwo [x, y] = []
removeLastTwo (x : xs) = x : removeLastTwo xs

doubleEveryOther :: [Int] -> [Int]
doubleEveryOther [] = []
doubleEveryOther [x] = [x]
doubleEveryOther [x, y] = [2 * x, y]
doubleEveryOther xs = doubleEveryOther (removeLastTwo xs) ++ doubleEveryOther (takeLastTwo xs)

-- Exercise 3 The output of doubleEveryOther has a mix of one-digit and two-digit numbers. Define the function
--  sumDigits :: [Integer] -> Integer
-- to calculate the sum of all digits.
-- Example: sumDigits [16,7,12,5] = 1 + 6 + 7 + 1 + 2 + 5 = 22

sumDigits :: [Int] -> Int
sumDigits [] = 0
sumDigits (x : xs)
  | x < 10 = x + sumDigits xs
  | otherwise = sumDigits (toDigits x) + sumDigits xs

-- Exercise 4 Define the function validate :: Integer -> Bool
-- that indicates whether an Integer could be a valid credit card num- ber. This will use all functions defined in the previous exercises.
-- Example: validate 4012888888881881 = True Example: validate 4012888888881882 = False

validate :: Int -> Bool
validate n = sumDigits (doubleEveryOther (toDigits n)) `mod` 10 == 0

-- Exercise 5 The Towers of Hanoi is a classic puzzle with a solution that can be described recursively. Disks of different sizes are stacked on three pegs; the goal is to get from a starting configuration with all disks stacked on the first peg to an ending configuration with all disks stacked on the last peg, as shown in Figure 1.
-- The only rules are
-- • you may only move one disk at a time, and
-- • a larger disk may never be stacked on top of a smaller one.
-- For example, as the first move all you can do is move the topmost, smallest disk onto a different peg, since only one disk may be moved at a time.
-- From this point, it is illegal to move to the configuration shown in Figure 3, because you are not allowed to put the green disk on top of the smaller blue one.
-- To move n discs (stacked in increasing size) from peg a to peg b using peg c as temporary storage,
-- 1. move n − 1 discs from a to c using b as temporary storage
-- 2. move the top disc from a to b
-- 3. move n − 1 discs from c to b using a as temporary storage. For this exercise, define a function hanoi with the following type:
--  type Peg = String
--  type Move = (Peg, Peg)
--  hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
-- 2Adapted from an assignment given in UPenn CIS 552, taught by Benjamin Pierce
-- ⇓
-- Figure 1: The Towers of Hanoi
-- Figure 2: A valid first move.
-- Figure 3: An illegal configuration.
-- Given the number of discs and names for the three pegs, hanoi should return a list of moves to be performed to move the stack of discs from the first peg to the second.
-- Note that a type declaration, like type Peg = String above, makes a type synonym. In this case Peg is declared as a synonym for String, and the two names Peg and String can now be used interchangeably. Giving more descriptive names to types in this way can be used to give shorter names to complicated types, or (as here) simply to help with documentation.
-- Example: hanoi 2 "a" "b" "c" == [("a","c"), ("a","b"), ("c","b")]

type Peg = String

type Move = (Peg, Peg)

hanoi :: Int -> Peg -> Peg -> Peg -> [Move]
hanoi 0 _ _ _ = []
hanoi 1 p_start p_dest p_temp = [(p_start, p_dest)]
hanoi n p_start p_dest p_temp = hanoi (n - 1) p_start p_temp p_dest ++ [(p_start, p_dest)] ++ hanoi (n - 1) p_temp p_dest p_start