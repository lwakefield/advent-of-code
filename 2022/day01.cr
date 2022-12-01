calories = STDIN.gets_to_end.split("\n\n").map do |chunk|
  chunk.lines.map(&.to_i32).sum
end

puts "part 1: #{calories.max}"

puts "part 2: #{calories.sort[-3..-1].sum}"
