n = String.to_integer(File.read!("input.txt"))

File.write!("output.txt", Enum.map_join(0..(n-1), "", fn i -> String.duplicate(" ", n - i - 1) <> String.duplicate("*", 2 * i + 1) <> "\n" end))
File.write!("output.txt", Enum.map_join((n-2)..0, "", fn i -> String.duplicate(" ", n - i - 1) <> String.duplicate("*", 2 * i + 1) <> "\n" end), [:append])
