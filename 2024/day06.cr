map = STDIN.gets_to_end
w = 1 + map.index! "\n"
i = map.index! "^"
dx, dy = 0, -1
path = [{i % w, i // w}]

loop do
    next_i = i + dx + dy * w
    if map[next_i]? == '#' # turn right
        dx, dy = -dy, dx
    elsif next_i < 0 || next_i >= map.size || next_i % w == w-1 # running off the edge...
        break
    else
        i = next_i
        path << {i % w, i // w}
    end
end
puts "Part 1: #{path.to_set.size}"