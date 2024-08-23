in_file = open('input.txt', 'r')
n = int(in_file.read().strip())

out_file = open('output.txt', 'w')

for i in range(n):
    out_file.write(' ' * (n - i - 1) + '*' * (2 * i + 1) + '\n')

for i in range(n - 2, -1, -1):
    out_file.write(' ' * (n - i - 1) + '*' * (2 * i + 1) + '\n')
