require "big"

instructions, nodes = (File.read ARGV.first).split(/\n\n/)

map = {} of String => Tuple(String, String)

nodes.lines.each do |l|
    _, a, b, c = l.match(/(\w+) = \((\w+), (\w+)\)/).not_nil!
    map[a] = {b, c}
end

pos = "AAA"
steps = 0
instructions.chars.cycle do |c|
    pos = case c
          when 'L' then map[pos][0]
          when 'R' then map[pos][1]
          else raise "err"
          end
    steps += 1
    break if pos == "ZZZ"
end

puts "Part 1: #{steps}"

pos = map.keys.select(&.ends_with?("A"))

def get_period (instructions, map, start)
    p = start
    steps = 0_u64
    instructions.chars.cycle do |c|
        p = case c
                when 'L' then map[p][0]
                when 'R' then map[p][1]
                else raise "err"
                end
        steps += 1
        return steps if p.ends_with? "Z"
    end
end

periods = pos.map{|p| get_period(instructions, map, p) }
puts "Part 2: #{periods.reduce(periods.first) do |acc, i|
    acc = acc.lcm(i)
end}"
