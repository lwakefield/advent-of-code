require "file"

engine = (File.read ARGV.first)

width = engine.match(/\n/).not_nil!.begin+1
part_numbers = engine.scan(/\d+/)
parts = engine.scan(/[^.\d\n]/)

puts "part 1: #{part_numbers.select do |pn|
    parts.find do |p|
        p.begin == pn.begin-1 ||
            p.begin == pn.end ||
            pn.begin-width-1 <= p.begin <= pn.end-width ||
            pn.begin+width-1 <= p.begin <= pn.end+width
    end
end.map(&.[0].to_i).sum}"

puts "part 2: #{parts.map do |p|
    next 0 unless p[0] == "*"
    ratio_parts = part_numbers.select do |pn|
        p.begin == pn.begin-1 ||
            p.begin == pn.end ||
            pn.begin-width-1 <= p.begin <= pn.end-width ||
            pn.begin+width-1 <= p.begin <= pn.end+width
    end.map(&.[0].to_i)
    ratio_parts.size == 2 ? ratio_parts.product : 0
end.sum}"