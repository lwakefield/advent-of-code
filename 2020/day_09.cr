numbers = [] of Int64
File.each_line("./day_09.txt") do |line|
  numbers << line.to_i64
end

chunk_size = 25
(0...(numbers.size - chunk_size)).each do |idx|
    chunk = numbers[idx...idx+chunk_size]
    is_valid = false
    chunk.combinations(2).each do |pair|
        is_valid = true if pair.sum == numbers[idx + chunk_size]
    end
    puts "preamble at #{idx} is invalid for [#{idx+chunk_size}]=#{numbers[idx+chunk_size]}" unless is_valid
end

# ans from p1: 1038347917 at index 646

target_idx = 646
target_val = numbers[target_idx]
preamble = numbers[...target_idx]
(2..).each do |n|
    preamble.each_cons(n) do |chunk|
        if chunk.sum == target_val
            puts chunk
            puts "min=#{chunk.min} max=#{chunk.max} min+max=#{chunk.min + chunk.max}"
            exit
        end
    end
end
