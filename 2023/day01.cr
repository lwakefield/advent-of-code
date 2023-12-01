require "file"

puts "part 1: #{File.read(ARGV.first).lines.map do |line|
    numbers = line.chars.select{|c| 48 <= c.ord <= 75 }
    calibration_value = "#{numbers.first}#{numbers.last}"
    calibration_value.to_i32
end.sum}"

puts "part 2: #{File.read(ARGV.first).lines.map do |line|
    numbers = line.scan /(?=(0|1|2|3|4|5|6|7|8|9|zero|one|two|three|four|five|six|seven|eight|nine))/
    lut = {
        "0" => 0,
        "1" => 1,
        "2" => 2,
        "3" => 3,
        "4" => 4,
        "5" => 5,
        "6" => 6,
        "7" => 7,
        "8" => 8,
        "9" => 9,
        # "zero" => 0,
        "one" => 1,
        "two" => 2,
        "three" => 3,
        "four" => 4,
        "five" => 5,
        "six" => 6,
        "seven" => 7,
        "eight" => 8,
        "nine" => 9
    }
    "#{lut[numbers.first[1]]}#{lut[numbers.last[1]]}".to_i32
end.sum}"