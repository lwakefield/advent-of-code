red_tiles = STDIN.gets_to_end.lines.map { |l| Tuple(Int64, Int64).from(l.split(",").map(&.to_i64)) }

def area(a, b)
  ax, ay = a
  bx, by = b
  ((bx - ax).abs + 1)*((by - ay).abs + 1)
end

largest = red_tiles.combinations(2).map do |p|
  area(p[0], p[1])
end.max
puts "part 1: #{largest}"

map = {} of Tuple(Int64, Int64) => Char
(red_tiles + [red_tiles.first]).each_cons_pair do |a, b|
  map[a] = '#'
  map[b] = '#'
  ax, ay = a
  bx, by = b
  (Math.min(ax, bx)..Math.max(ax, bx)).each do |x|
    (Math.min(ay, by)..Math.max(ay, by)).each do |y|
      map[{x, y}] ||= 'X'
    end
  end
end



def find_start (tiles, map)
  minx, maxx = tiles.minmax_by(&.[0]).map(&.[0])
  miny, maxy = tiles.minmax_by(&.[1]).map(&.[1])
  ((miny - 1)..(maxy + 1)).each do |y|
    ((minx - 1)..(maxx + 1)).each do |x|
      if map[{x - 2, y}]?.nil? && !map[{x - 1, y}]?.nil? && map[{x, y}]?.nil?
        return {x, y}
      end
    end
  end
end

# NOTE: doesn't seem like flood filling is a viable option (within 2Gi of RAM at least)
# to_fill = [ find_start(red_tiles, map).not_nil! ]
# until to_fill.empty?
#   x, y = to_fill.shift
#   map[{x,y}] = 'X'
#   [
#       {x, y-1},
#       {x, y+1},
#       {x-1, y},
#       {x+1, y},
#   ].each do |p|
#     to_fill << p unless map[p]?
#   end
# end

# minx, maxx = red_tiles.minmax_by(&.[0]).map(&.[0])

# miny, maxy = red_tiles.minmax_by(&.[1]).map(&.[1])
# ((miny - 1)..(maxy + 1)).each do |y|
#   ((minx - 1)..(maxx + 1)).each do |x|
#     STDOUT << (map[{x,y}]? || '.')
#   end
#   STDOUT << '\n'
# end

# def is_valid (a, b, map)
#   (miny..maxy).each do |y|
#     (minx..maxx).each do |x|
#     end
#   end
# end

# largest = 0u64
# red_tiles.combinations(2).each do |p|
#   minx, maxx = p.map(&.[0]).minmax
#   miny, maxy = p.map(&.[1]).minmax
#   is_valid = (miny..maxy).all? do |y|
#     (minx..maxx).all? do |x|
#       map[{x,y}]?
#     end
#   end

#   next unless is_valid

#   a = area(p[0], p[1])
#   puts "#{p} -> #{a}"

#   largest = Math.max largest, a
# end
# puts "part 2: #{largest}"