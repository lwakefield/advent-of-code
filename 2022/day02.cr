input = STDIN.gets_to_end.lines.map{|l| Tuple(String,String).from(l.split " ")}

score = 0
input.each do |them, us|
  case {them, us}
  # losses
  when {"A", "Z"} then score += 0 + 3
  when {"B", "X"} then score += 0 + 1
  when {"C", "Y"} then score += 0 + 2
  # draws
  when {"A", "X"} then score += 3 + 1
  when {"B", "Y"} then score += 3 + 2
  when {"C", "Z"} then score += 3 + 3
  # wins
  when {"A", "Y"} then score += 6 + 2
  when {"B", "Z"} then score += 6 + 3
  when {"C", "X"} then score += 6 + 1
  end
end

puts "part 1: #{score}"

score = 0
input.each do |them, outcome|
  case {outcome, them}
  # losses
  when {"X", "A"} then score += 0 + 3
  when {"X", "B"} then score += 0 + 1
  when {"X", "C"} then score += 0 + 2
  # draws
  when {"Y", "A"} then score += 3 + 1
  when {"Y", "B"} then score += 3 + 2
  when {"Y", "C"} then score += 3 + 3
  # wins
  when {"Z", "A"} then score += 6 + 2
  when {"Z", "B"} then score += 6 + 3
  when {"Z", "C"} then score += 6 + 1
  end
end

puts "part 2: #{score}"
