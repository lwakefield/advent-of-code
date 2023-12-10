map = (File.read ARGV.first)
w = map.index('\n').not_nil!
sx = map.index('S').not_nil! % (w+1)
sy = map.index('S').not_nil! // (w+1)

def lookup(p, map)
    w = map.index('\n').not_nil!
    x, y = p
    return nil if x < 0 || x >= w
    return nil if y < 0 || y >= map.size // (w+1)
    map[(w+1)*y + x]
end

def find_pipes (p, map)
    w = map.index('\n').not_nil!
    x, y = p

    north, south, east, west = {0,-1},{0,+1},{+1,0},{-1,0}

    pipe_move_options = {
        north => ['|','F','7'],
        south => ['|','L','J'],
        west  => ['-','F','L'],
        east  => ['-','J','7'],
    }

    case lookup(p,map)
    when 'S' then [north, south, east, west]
    when '|' then [north, south]
    when '-' then [east, west]
    when 'L' then [north, east]
    when 'J' then [north, west]
    when '7' then [south, west]
    when 'F' then [south, east]
    else raise "invalid pos: #{p}"
    end.reduce([] of Tuple(Int32,Int32)) do |acc, i|
        dx, dy = i
        acc << {x+dx,y+dy} if pipe_move_options[i].includes? lookup({x+dx,y+dy},map)
        acc
    end
end

v = Set(Tuple(Int32,Int32)).new
q = [{sx,sy}]
puts "Part 1: #{(0..).find do |i|
    q_tmp = Set(Tuple(Int32, Int32)).new
    until q.empty?
        n = q.shift
        v << n
        q_tmp += find_pipes(n, map).to_set - v
    end
    q = q_tmp.to_a
    q.empty?
end}"

inside = Set(Tuple(Int32,Int32)).new
(0...map.size // (w+1)).each do |y|
    isect_count = 0
    (0..w).each do |x|
        isect_count += 1 if v.includes?({x,y}) && ['|','F','7'].includes? lookup({x,y},map) # S is an L in the real data, add it back for test data
        inside << {x,y} if (isect_count % 2 == 1) && !v.includes?({x,y})
    end
end
puts "Part 2: #{inside.size}"
