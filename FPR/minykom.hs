type Result = [String]

pp :: Result -> IO ()
pp x = putStr (concat (map (++"\n") x))

minesweeper :: Result -> Result
minesweeper input = row input (toTuple input 8) 8 
sampleInput = ["       ",
               " *     ",
               "    *  ",
               "   *   ",
               "      *",
               "***    ",
               "* *    ",
               "***    "]

toTuple :: Result -> Int -> [(Int, Int)]--zjišťění souřadnic min - řádky
toTuple [] _ = []
toTuple (x:xs) row = filter ((> 0).fst) (toTupleRow x row 7 ++ toTuple xs (row - 1))

toTupleRow :: [Char] -> Int -> Int ->  [(Int, Int)]--zjištění souřadnic min - sloupce
toTupleRow [] _ _ = []
toTupleRow (x:xs) row element = if x == '*' then (row, element) : toTupleRow xs row (element - 1) else (0, 0) : toTupleRow xs row (element - 1)

row :: Result -> [(Int, Int)] -> Int -> Result--zjištění souřadnic prvků - řádky a spojení Stringů(jednotlivých řádků) do konečného pole - [String] => Result
row [] _ _ = []
row (x:xs) mins rowIndex = elements x mins rowIndex 7 : row xs mins (rowIndex - 1)

elements :: [Char] -> [(Int, Int)] -> Int -> Int -> String--zjištění souřadnic prvků - sloupce a spojení jednotlivých prvků(miny a čísla(převedé do stringu)) do sloupce
elements [] _ _ _ = []
elements (x:xs) mins rowIndex elementIndex = element x mins rowIndex elementIndex ++ elements xs mins rowIndex (elementIndex - 1)

element :: Char -> [(Int, Int)] -> Int -> Int -> [Char]--součet a převod(do Stringu) čísla označující počet prvků s minami, s kterými daný prvek sousedí
element '*' _ _ _ = "*"
element x mins rowIndex elementIndex = show (nearMin mins (rowIndex + 1) (elementIndex + 1) +
                                             nearMin mins (rowIndex + 1) (elementIndex) +
                                             nearMin mins (rowIndex + 1) (elementIndex - 1) +
                                             nearMin mins (rowIndex) (elementIndex + 1) +
                                             nearMin mins (rowIndex) (elementIndex - 1) +
                                             nearMin mins (rowIndex - 1) (elementIndex + 1) +
                                             nearMin mins (rowIndex - 1) (elementIndex) +
                                             nearMin mins (rowIndex - 1) (elementIndex - 1))

nearMin :: [(Int, Int)] -> Int -> Int -> Int--zjištění, zda daný sousední prvek obsahuje minu
nearMin [] _ _ = 0
nearMin (x:xs) rowIndex elementIndex = if fst x == rowIndex then (if snd x == elementIndex then 1 else nearMin xs rowIndex elementIndex) else nearMin xs rowIndex elementIndex

atLeastOne :: Result -> Int
atLeastOne [] = 0
atLeastOne (x:xs) = split x + atLeastOne xs

split :: [Char] -> Int
split [] = 0
split (x:xs) = if x == '*' then 1 else split xs