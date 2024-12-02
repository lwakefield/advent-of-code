left, right = [] of Int32, [] of Int32
STDIN.each_line do |line|
    a, b = line.split
    left.push(a.to_i)
    right.push(b.to_i)
end
left.sort!
right.sort!
distances = left.zip(right).map do |a, b|
    (b - a).abs
end
puts "Part 1: #{distances.sum}"

occurences = right.reduce({} of Int32 => Int32) do |acc, x|
    acc[x] ||= 0
    acc[x] += 1
    acc
end

similarity = left.reduce(0) do |acc, x|
    acc += x * (occurences[x]? || 0)
    acc
end
puts "Part 2: #{similarity}"