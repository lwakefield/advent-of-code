_crates, instructions = STDIN.gets_to_end.split("\n\n").map(&.lines)

crates = {} of Int32 => Array(String)
_crates.reverse[1..].each do |line|
  line.chars.each_slice(4).each_with_index do |c, i|
    crates[i+1] ||= [] of String
    crates[i+1] << c[1].to_s unless c[1] == ' '
  end
end

crates1 = crates.dup.transform_values(&.dup)
instructions.each do |inst|
  num, from, to = inst.scan(/\d+/).map(&.[0].to_i32)
  num.times do
    next if crates1[from].empty?
    crates1[to] << crates1[from].pop
  end
end

puts "part 1: #{(1..crates1.size).map{|i| crates1[i].last}.join}"

crates2 = crates.dup.transform_values(&.dup)
instructions.each do |inst|
  num, from, to = inst.scan(/\d+/).map(&.[0].to_i32)
  crates2[to] += crates2[from].pop(num)
end
puts "part 2: #{(1..crates2.size).map{|i| crates2[i].last}.join}"
