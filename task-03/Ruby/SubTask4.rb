n = File.read('input.txt').to_i

File.open('output.txt', 'w') do |outfile|
  n.times do |i|
    outfile.puts ' ' * (n - i - 1) + '*' * (2 * i + 1)
  end
  (n-1).times do |i|
    outfile.puts ' ' * (i + 1) + '*' * (2 * (n - i - 2) + 1)
  end
end
