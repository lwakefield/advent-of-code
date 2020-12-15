numbers = (ARGV.first? || "9,12,1,4,17,0,18").split(",").map(&.to_i)
until numbers.size == 2020
    prev_idx = numbers.rindex(numbers.last, -2)
    numbers << (prev_idx ? (numbers.size - 1 - prev_idx.not_nil!) : 0)
end
puts "part 1: #{numbers.last}"

numbers = (ARGV.first? || "9,12,1,4,17,0,18").split(",").map(&.to_i)
number_map = {} of Int32 => Array(Int32)
numbers.each_with_index do |v, idx|
    number_map[v] ||= [] of Int32
    number_map[v] << idx
end

last_number = numbers.last
(numbers.size...30000000).each do |idx|
    indexes = number_map[last_number]
    next_number = indexes.size == 1 ? 0 : indexes[-1] - indexes[-2]

    number_map[next_number] ||= [] of Int32
    number_map[next_number] << idx
    last_number = next_number

    puts idx / 30000000 if idx % 10000 == 0
end
puts "part 2: #{last_number}"
