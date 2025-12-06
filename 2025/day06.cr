lines = STDIN.gets_to_end.lines
operands, ops = lines[0...-1].map(&.split.map(&.to_u64)), lines[-1].split

n = operands.first.size
answer = (0...n).map do |i|
    case ops[i]
    when "+" then operands.map(&.[i]).sum
    when "*" then operands.map(&.[i]).product
    else raise "unhandled op: #{ops[i]}"
    end
end.sum
puts "part 1: #{answer}"

# okay we need to reparse everything... the ops are always at the start which helps...

operands, ops = lines[0...-1], lines.last
ranges = ops.scan(/[+*]\s+(?=\s[+*]|$)/).map do |m|
    m.begin...m.end
end
answer = ranges.map do |r|
    vals = r.reverse_each.map do |i|
        operands.reduce(0u64) do |acc, curr|
            unless curr[i].whitespace?
                acc *= 10
                acc += curr[i].to_u64
            end
            acc
        end
    end.to_a
    case ops[r][0]
    when '+' then vals.sum
    when '*' then vals.product
    else raise "unhandled op: #{ops[r][0]}"
    end
end.sum
puts "part 2: #{answer}"