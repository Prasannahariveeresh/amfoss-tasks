main :: IO ()
main = do
    putStrLn "Enter a number: "
    input <- getLine

    let n = read input :: Int

    mapM_ putStrLn [replicate (n - i - 1) ' ' ++ replicate (2 * i + 1) '*' | i <- [0..n-1]]
    mapM_ putStrLn [replicate (n - i - 1) ' ' ++ replicate (2 * i + 1) '*' | i <- [n-2,n-3..0]]