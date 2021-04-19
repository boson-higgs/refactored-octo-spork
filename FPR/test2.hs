countIt :: Eq a => a -> [a] -> Int
countIt _ [] = 0
countIt a (x:xs) | x == a = 1 + (countIt a xs)
                        | otherwise = countIt a xs


max' :: [Int] -> [Int]
max' [] = []
max' (x:[]) = []
max' (x:y:[]) = []
max' (x:y:z:zs)
    | y > z && y > x = y: max' (y:z:zs)
    | otherwise = max' (y:z:zs)