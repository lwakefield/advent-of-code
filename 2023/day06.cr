require "big"

input = (File.read ARGV.first)

t, d = input.split /\n/
t = t.split(":")[1].split.map(&.strip).reject(&.empty?).map(&.to_i)
d = d.split(":")[1].split.map(&.strip).reject(&.empty?).map(&.to_i)

puts "Part 1: #{t.zip(d).map do |rt, rd|
    (0..rt).select do |t|
        t * (rt - t) > rd
    end.size
end.product}"

t, d = input.split /\n/
t = t.split(":")[1].split.map(&.strip).reject(&.empty?).join.to_big_i
d = d.split(":")[1].split.map(&.strip).reject(&.empty?).join.to_big_i

rt, rd = t, d
puts "Part 2: #{(0..rt).select do |t|
    t.to_big_i * (rt.to_big_i - t.to_big_i) > rd.to_big_i
end.size}"
