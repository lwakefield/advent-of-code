rules, updates = STDIN.gets_to_end.split "\n\n"

rules = rules.lines.map do |rule|
    a, b = rule.split("|").map(&.to_i)
    {a, b}
end.to_set

updates = updates.lines.map do |update|
    update.split(",").map(&.to_i)
end

valid_updates = updates.select do |update|
    (0...update.size).all? do |i|
        (i+1...update.size).all? do |j|
            if rules.includes?({update[i], update[j]})
                true
            elsif rules.includes?({update[j], update[i]})
                false
            else
                true
            end
        end
    end
end
puts "Part 1: #{valid_updates.map {|u| u[u.size//2]}.sum}"

fixed_updates = updates.map do |update|
    update.sort do |a, b|
        if rules.includes?({a, b})
            -1
        elsif rules.includes?({b, a})
            1
        else
            0
        end
    end
end
puts "Part 2: #{fixed_updates.map {|u| u[u.size//2]}.sum - valid_updates.map {|u| u[u.size//2]}.sum}"