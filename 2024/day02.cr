levels = [] of Array(Int32)
STDIN.each_line do |line|
    levels << line.split.map(&.to_i)
end

def is_safe(level)
    dir = (level[1] - level[0]).sign
    level.each_cons(2).all? do |pair|
        a, b = pair
        (1 <= (a-b).abs <= 3) && (b-a).sign == dir
    end
end

num_safe = levels.reduce(0) do |acc, level|
    acc += 1 if is_safe(level)
    acc
end
puts "Part 1: #{num_safe}"

num_safe = levels.reduce(0) do |acc, level|
    if is_safe(level)
        acc += 1
    elsif (0...level.size).any? do |i|
            is_safe level[0...i] + level[i+1..-1]
        end
        acc += 1
    end
    acc
end
puts "Part 2: #{num_safe}"