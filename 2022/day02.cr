their_map = { "A" => "r", "B" => "p", "C" => "s" }
our_map   = { "X" => "r", "Y" => "p", "Z" => "s" }

input = STDIN.gets_to_end.lines

score = 0
input.each do |line|
  them, us = line.split " "

  case {their_map[them], our_map[us]}
  when {"r", "p"}, {"p", "s"}, {"s", "r"} then score += 6
  when {"r", "r"}, {"p", "p"}, {"s", "s"} then score += 3
  when {"r", "s"}, {"p", "r"}, {"s", "p"} then score += 0
  end

  case our_map[us]
  when "r" then score += 1
  when "p" then score += 2
  when "s" then score += 3
  end
end

puts "part 1: #{score}"

score = 0
input.each do |line|
  them, outcome = line.split " "

  case {outcome, their_map[them]}
  when {"X", "r"} then score += 0 + 3
  when {"X", "p"} then score += 0 + 1
  when {"X", "s"} then score += 0 + 2
  when {"Y", "r"} then score += 3 + 1
  when {"Y", "p"} then score += 3 + 2
  when {"Y", "s"} then score += 3 + 3
  when {"Z", "r"} then score += 6 + 2
  when {"Z", "p"} then score += 6 + 3
  when {"Z", "s"} then score += 6 + 1
  end
end

puts "part 2: #{score}"
