swap::String->Char->Char->String --swap"ABCDABCD"'A''X'="XBCDXBCD"
swap [] a y = []
swap (x:xs) a y = if x == a then y : swap xs a y else x : swap xs a y



average::[Double]->Double --average[1,2,3,4]--2.5
average [x] = x
average x = sum x / fromIntegral (length x)



accounts::[(String,Int)]->[String] ----accounts[("A",100),("B",-1),("C",10)]=["A","C"]
accounts a = [x | (x, y) <- a, y > 0]

