puts "Enter a number: "
n = gets.to_i

n.times do |i|
  puts ' ' * (n - i - 1) + '*' * (2 * i + 1)
end

(n-1).times do |i|
  puts ' ' * (i + 1) + '*' * (2 * (n - i - 2) + 1)
end
