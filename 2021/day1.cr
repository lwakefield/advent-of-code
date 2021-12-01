measurements = STDIN.gets_to_end.lines.map(&.to_i32)

increases = 0

measurements.each_cons(2) do |pair|
  left, right = pair
  increases += 1 if right > left
end

puts "part 1: #{increases}"


increases = 0

measurements.each_cons(4) do |set|
  a, b, c, d = set
  increases += 1 if b + c + d > a + b + c
end

puts "part 2: #{increases}"
