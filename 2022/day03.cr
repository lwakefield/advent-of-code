rucksacks = STDIN.gets_to_end.lines

priorities = rucksacks.map do |line|
  left, right =  line[...line.size//2], line[line.size//2..]

  overlap = left.chars.to_set & right.chars.to_set
  raise "err" if overlap.size > 1
  overlap = overlap.first

  if overlap.lowercase?
    overlap.ord - 'a'.ord + 1
  elsif overlap.uppercase?
    overlap.ord - 'A'.ord + 27
  else
    raise "err"
  end
end

puts "part 1: #{priorities.sum}"

priorities = rucksacks.map(&.chars.to_set).in_groups_of(3).map do |lines|
  raise "err" unless lines[0] && lines[1] && lines[2]
  lines = lines.map(&.not_nil!)

  overlap = lines[0] & lines[1] & lines[2]
  raise "err" if overlap.size > 1
  overlap = overlap.first

  if overlap.lowercase?
    overlap.ord - 'a'.ord + 1
  elsif overlap.uppercase?
    overlap.ord - 'A'.ord + 27
  else
    raise "err"
  end
end

puts "part 2: #{priorities.sum}"
