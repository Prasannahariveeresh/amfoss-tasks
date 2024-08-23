use std::io;

fn main() {
    println!("Enter a number: ");
    let mut input = String::new();
    io::stdin().read_line(&mut input).expect("Failed to read line");
    let n: usize = input.trim().parse().expect("Please enter a number");

    for i in 0..n {
        println!("{}{}", " ".repeat(n - i - 1), "*".repeat(2 * i + 1));
    }
    for i in (0..n-1).rev() {
        println!("{}{}", " ".repeat(n - i - 1), "*".repeat(2 * i + 1));
    }
}
