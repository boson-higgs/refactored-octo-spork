--vstup: pp(drawLines (31,15) [Line (Point x y) (Point 15 7)|(x,y)<-concat [[(x,y)|y<-[0,7,14]]|x<-[0,15,30]]])

type Result = [String]
pp :: Result -> IO ()
pp x = putStr (concat (map (++"\n") x))

data Point = Point Int Int
data Line = Line Point Point

drawLines :: (Int,Int) -> [Line] -> Result
drawLines n lines = prints (getMap n) lines

prints :: [String] -> [Line] -> Result
prints a [] = a
prints a (x:xs) = prints (printLine x a) xs 

getMap :: (Int, Int) -> [String]
getMap (_, 0) = []
getMap (n, m) = getRow n : getMap (n, (m - 1))

getRow :: Int -> String
getRow 0 = []
getRow n = "." ++ getRow (n - 1)

printLine :: Line -> [String] -> [String]
printLine (Line (Point n m) (Point y x)) s
    | (n > y && m == x) = fillLine (n + 1) m y x s
    | (n /= y && m == x) = fillLine n m (y + 1) x s
    | (m > x && n == y) = fillLine n (m + 1) y x s
    | (m /= x && n == y) = fillLine n m y (x + 1) s
    | otherwise = fillDiagonal n m y x s

fillLine :: Int -> Int -> Int -> Int -> [String] -> [String]
fillLine n m y x a 
    | (n > y && m == x) = fillLine (y + 1) m n x (setRow y m 0 a) 
    | (n /= y && m == x) = fillLine (n + 1) m y x (setRow n m 0 a)
    | (m > x && n == y) = fillLine n (x + 1) y m (setRow n x 0 a)
    | (m /= x && n == y) = fillLine n (m + 1) y x (setRow n m 0 a)
    | otherwise = a

setRow :: Int -> Int -> Int -> [String] -> [String]
setRow _ _ _ [] = [] 
setRow n m am (x:xs) = if(m == am) then (setCol n 0 x : xs) else (x : setRow n m (am + 1) xs)

setCol :: Int -> Int -> String -> String
setCol _ _ [] = []
setCol n an (x:xs) = if(n == an) then ('#' : xs) else (x : setCol n (an + 1) xs)

fillDiagonal :: Int -> Int -> Int -> Int -> [String] -> [String]
fillDiagonal n m y x a
    | (n < y && m < x) = fillLU n m (y + 1) x a
    | (n > y && m > x) = fillLU (y - 1) x n m a
    | (n > y && m < x) = fillRU n m (y + 1) x a
    | (n < y && m > x) = fillRD n m (y + 1) x a
    | otherwise = a

fillLU :: Int -> Int -> Int -> Int -> [String] -> [String]
fillLU n m y x a
    | (y == 0 && x == 0) = a
    | (y <= (x * 2)) = fillLU n (m + 1) y (x - 1) (setRow n m 0 a)
    | otherwise = fillLU (n + 1) m (y - 1) x (setRow n m 0 a)

fillRU :: Int -> Int -> Int -> Int -> [String] -> [String]
fillRU n m y x a
    | (y == 0 && x == 0) = a
    | (y <= (x * 2)) = fillRU n (m + 1) y (x - 1) (setRow n m 0 a)
    | otherwise = fillRU (n - 1) m (y - 1) x (setRow n m 0 a)

fillRD :: Int -> Int -> Int -> Int -> [String] -> [String]
fillRD n m y x a
    | (y == 0 && x == 0) = a
    | (y <= (x * 2)) = fillRD n (m - 1) y (x - 1) (setRow n m 0 a)
    | otherwise = fillRD (n + 1) m (y - 1) x (setRow n m 0 a)