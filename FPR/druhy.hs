-- n! = n*(n-1)*(n-2)...3*2*1
-- 3! = 3 * 2 * 1
-- https://en.wikipedia.org/wiki/Factorial
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n -1)

--Xn = Xn−1 + Xn−2
-- https://en.wikipedia.org/wiki/Fibonacci_number
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n -1) + fib (n -2)

leapYear :: Int -> Bool
leapYear rok = ((mod rok 4) == 0) && ((mod rok 100) /= 0) || ((mod rok 400) == 0)

max2 :: Int -> Int -> Int
max2 a b = if a > b then a else b

max3 :: Int -> Int -> Int -> Int
max3 a b c = max2 a (max2 b c)

combinations :: Int -> Int -> Int
combinations k n = (factorial n) `div` (factorial (n - k) * factorial k)

numberOfRoots :: Int -> Int -> Int -> Int
numberOfRoots a b c
  | d > 0 = 2
  | d == 0 = 1
  | d < 0 = 0
  where
    d = b * b - 4 * c * a

gcd' :: Int -> Int -> Int
gcd' u w
  | w /= 0 = gcd w (u `mod` w)
  | w == 0 = u

-- isPrime2

isPrimeSimple :: Int -> Int -> Bool
isPrimeSimple org divisor
  | divisor < 2 = True
  | (org `mod` divisor) == 0 = False
  | otherwise = isPrimeSimple org (divisor -1)

isPrime :: Int -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime 2 = True
isPrime x = isPrimeSimple x (x -1)

pole_primu :: [Int]
pole_primu = [x | x <- [0, 1 ..], isPrime x == True]
