rows = STDIN.gets_to_end.lines.map(&.chars)

splits = 0
part1 = rows.clone
part1.each_cons_pair do |row, next_row|
    row.each_with_index do |c, i|
        next unless c == 'S' || c == '|'
        case next_row[i]
        when '^' then next_row[i-1], next_row[i+1], splits = '|', '|', splits+1
        when '.' then next_row[i] = '|'
        when '|' then # noop
        else raise "could not handle #{row[i]} @ #{i}"
        end
    end
end
puts "part 1: #{splits}"

def dfs (point, map, cache = {} of Tuple(Int32, Int32) => UInt64)
    return cache[point] if cache[point]?
    x, y = point

    if y+1 == map.size
        cache[point] = 1u64
        cache[point]
    elsif map[y+1][x] == '^'
        cache[point] = dfs({x-1,y+1}, map, cache) + dfs({x+1,y+1}, map, cache)
        cache[point]
    else
        dfs({x, y+1}, map, cache)
    end
end
puts "part 2: #{dfs({rows.first.index!('S'), 0}, rows)}"
