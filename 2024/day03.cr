program = STDIN.gets_to_end
res = program.scan(/mul\((\d+),(\d+)\)/).each.reduce(0) do |acc, match|
    a, b = match[1].to_i, match[2].to_i
    acc += a * b
end
puts "Part 1: #{res}"

enabled = true
res = program.scan(/do\(\)|don't\(\)|mul\((\d+),(\d+)\)/).each.reduce(0) do |acc, match|
    if match.to_s == "do()"
        enabled = true
    elsif match.to_s == "don't()"
        enabled = false
    elsif match.to_s.starts_with?("mul(")
        a, b = match[1].to_i, match[2].to_i
        acc += a * b if enabled
    end
    acc
end
puts "Part 2: #{res}"