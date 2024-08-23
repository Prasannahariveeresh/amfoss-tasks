IO.write("Enter a number: ")
n = String.to_integer(IO.gets(""))

for i <- 0..(n-1) do
  IO.puts String.duplicate(" ", n - i - 1) <> String.duplicate("*", 2 * i + 1)
end

for i <- (n-2)..0 do
  IO.puts String.duplicate(" ", n - i - 1) <> String.duplicate("*", 2 * i + 1)
end