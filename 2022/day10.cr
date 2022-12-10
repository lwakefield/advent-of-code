instructions = STDIN.gets_to_end.lines

adds = instructions.reduce([] of Int32) do |a, v|
  if v == "noop"
    a << 0
  elsif v.starts_with? "addx"
    a << 0
    a << v.split(" ")[1].to_i32
  else
    raise "err"
  end
  a
end
samples = [
  20 * (1+adds[0..18].sum),
  60 * (1+adds[0..58].sum),
  100 * (1+adds[0..98].sum),
  140 * (1+adds[0..138].sum),
  180 * (1+adds[0..178].sum),
  220 * (1+adds[0..218].sum),
]
puts "part 1: #{samples.sum}"

screen = ""
rx = 1
adds.each_with_index do |add, cycle|
  if (rx-1..rx+1).includes? (cycle%40)
    screen += "#"
  else
    screen += "."
  end

  rx += add
end

puts "part 2"
puts "------"
puts screen.chars.each_slice(40).map{|c| c.join }.join("\n")
