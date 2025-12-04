banks = STDIN.gets_to_end.lines

joltage = 0
banks.each do |bank|
    largest = 0
    (0...bank.size).each do |i|
        (i+1...bank.size).each do |j|
            v = (bank[i].to_i * 10) + bank[j].to_i
            largest = v if v > largest
        end
    end
    joltage += largest
end
puts "part 1: #{joltage}"

# part two requires 12 batteries, so we need a new approach (or we could try copy pasting 12 times?)

total = 0i64
banks.each do |bank|
    joltage = 0i64
    last = -1
    (0...12).each do |i|
        largest, idx = 0, -1
        (last+1...bank.size-(12-i-1)).each do |j|
            largest, idx = bank[j].to_i, j if bank[j].to_i > largest
            break if largest == 9
        end
        joltage *= 10
        joltage += largest
        last = idx
    end
    puts "joltage: #{joltage}"
    total += joltage
end
puts "part 2: #{total}"