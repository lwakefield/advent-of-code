map = {} of Tuple(Int32, Int32) => Char
STDIN.gets_to_end.lines.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    map[{x, y}] = c
  end
end

def find_accessible(map)
    width, height = map.keys.map(&.[0]).max, map.keys.map(&.[1]).max
    accessible = [] of Tuple(Int32,Int32)
    (0..height).each do |y|
        (0..width).each do |x|
            next unless map[{x,y}] == '@'
            neighbor_rolls = 0
            [
            {-1, -1}, {0, -1}, {1, -1},
            {-1, 0}, {1, 0},
            {-1, 1}, {0, 1}, {1, 1},
            ].each do |dir|
            dx, dy = dir
            neighbor_rolls += 1 if map[{x + dx, y + dy}]? == '@' || map[{x + dx, y + dy}]? == 'x'
            end
            accessible << {x,y} if neighbor_rolls < 4
        end
    end
    accessible
end

puts "part 1: #{find_accessible(map).size}"

latest = map.clone
removed = 0
until (a = find_accessible latest).size == 0
    a.each do |xy|
        latest[xy] = '.'
        removed += 1
    end
end
puts "part 2: #{removed}"