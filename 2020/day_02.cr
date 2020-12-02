def is_valid_part_one (min, max, char, password)
    counts = {} of Char => Int32
    password.chars.each do |c|
        counts[c] ||= 0
        counts[c] += 1
    end

    counts[char]? && counts[char] >= min && counts[char] <= max
end

def is_valid_part_two (min, max, char, password)
    (password[min - 1]? == char) ^ (password[max - 1]? == char)
end

valid_count_part_one = 0
valid_count_part_two = 0

File.read_lines("day_02.txt").each do |line|
    match = line.match /(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<password>\w+)/
    match = match.not_nil!
    min = match["min"].to_i
    max = match["max"].to_i
    char = match["char"].chars.first # there should only be one
    password = match["password"]

    valid_count_part_one += 1 if is_valid_part_one(min, max, char, password)
    valid_count_part_two += 1 if is_valid_part_two(min, max, char, password)
end

puts valid_count_part_one
puts valid_count_part_two
