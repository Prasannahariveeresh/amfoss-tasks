use std::fs;

fn main() {
    let n = fs::read_to_string("input.txt")
        .expect("Unable to read file")
        .trim()
        .parse::<usize>()
        .expect("Unable to parse");

    let mut output = String::new();

    for i in 0..n {
        output.push_str(&" ".repeat(n - i - 1));
        output.push_str(&"*".repeat(2 * i + 1));
        output.push_str("\n");
    }
    for i in (0..n-1).rev() {
        output.push_str(&" ".repeat(n - i - 1));
        output.push_str(&"*".repeat(2 * i + 1));
        output.push_str("\n");
    }

    fs::write("output.txt", output).expect("Unable to write file");
}
