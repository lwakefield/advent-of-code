groups = File.read("day_06.txt").split("\n\n").map do |lines|
    counts = {} of Char => Int32
    lines.chars.each do |c|
        next if c.whitespace?
        counts[c] ||= 0
        counts[c] += 1
    end
    { lines.lines.size, counts }
end

puts groups.map{ |g| g[1].size }.sum

puts(groups.map do |group_size, counts|
    counts.values.select { |v| v == group_size }.size
end.sum)
