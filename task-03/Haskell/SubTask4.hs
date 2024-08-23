main :: IO ()
main = do
    n <- readFile "input.txt"

    let num = read (head (lines n)) :: Int
    let topHalf = [replicate (num - i - 1) ' ' ++ replicate (2 * i + 1) '*' | i <- [0..num-1]]
    let bottomHalf = [replicate (num - i - 1) ' ' ++ replicate (2 * i + 1) '*' | i <- [num-2,num-3..0]]

    writeFile "output.txt" $ unlines (topHalf ++ bottomHalf)
