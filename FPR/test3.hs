--1
data Firma = Firma { nazev :: String, zamestnanci :: Int, firmy :: [Firma] } deriving (Eq, Show)
sampleInput = Firma "Facebook" 15000 [
                                        Firma "Instagram" 8000 [],
                                        Firma "WhatsApp" 2000 []
                                     ]


--2
type Jmeno = String
type Rocnik = Int
data Pohlavi = Muz | Zena
data Rodina = Rodina Jmeno Rocnik Pohlavi [Rodina] 

malaRodina :: Rodina
malaRodina = Rodina "Jan" 1945 Muz [
                            Rodina "Jiri" 1965 Muz [],
                            Rodina "Dana" 1968 Zena [
                                                        Rodina "Jan" 1988 Muz [] ,
                                                        Rodina "Marta" 1955 Zena []
                                                    ]
                                    ]

pocetZen :: Rodina -> Int
pocetZen x = countW [x]

countW :: [Rodina] -> Int
countW [] = 0
countW (x:xs) = count x + countW xs

count :: Rodina -> Int
count (Rodina _ _ Zena x) = 1 + countW x
count (Rodina _ _ _ x) = countW x 


--3
over :: Rodina -> Bool
over (Rodina _  datum _  x) = isyounger x datum

isyounger :: [Rodina] -> Int -> Bool
isyounger [] _ = True
isyounger ((Rodina _ datum _ x):xs) yo = if (datum == yo) then (isyounger xs yo) else (False)