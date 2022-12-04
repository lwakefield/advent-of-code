assignments = STDIN.gets_to_end.lines.map do |line|
  left, right = line.split(",").map(&.split("-").map(&.to_i32))
  left, right = left[0]..left[1], right[0]..right[1]
  { left, right }
end

overlaps = assignments.select do |left, right|
  (left.begin <= right.begin && left.end >= right.end) ||
    (right.begin <= left.begin && right.end >= left.end)
end

puts "part 1: #{overlaps.size}"

overlaps = assignments.select do |left, right|
  right.begin <= left.end <= right.end ||
    left.begin <= right.end <= left.end
end

puts "part 2: #{overlaps.size}"
