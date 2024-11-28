use std::fs;

fn part_one(s: &str) {
    println!("Part one: ");
}

fn part_two(s: &str) {
    println!("Part two: ");
}

fn main() {
    let debug = true;
    let filename = match debug {
        true => "inputs/aoc??d?_test.txt",
        false => "inputs/aoc??d?.txt"
    }
    let contents = fs::read_to_string(filename).unwrap();
    part_one(&contents);
    part_two(&contents);
}
