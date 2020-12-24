# a b c
#  d e f
# g h i

alias Vec2 = Tuple(Int32, Int32)

def add(a, b)
  {a[0] + b[0], a[1] + b[1]}
end

def east(pos)
  add(pos, {1, 0})
end

def south_east(pos)
  add(pos, pos[1] % 2 == 0 ? {0, -1} : {1, -1})
end

def south_west(pos)
  add(pos, pos[1] % 2 == 0 ? {-1, -1} : {0, -1})
end

def west(pos)
  add(pos, {-1, 0})
end

def north_west(pos)
  add(pos, pos[1] % 2 == 0 ? {-1, 1} : {0, 1})
end

def north_east(pos)
  add(pos, pos[1] % 2 == 0 ? {0, 1} : {1, 1})
end

def get_neighbors(tiles, pos)
  [
    tiles[east(pos)]? || "white",
    tiles[south_east(pos)]? || "white",
    tiles[south_west(pos)]? || "white",
    tiles[west(pos)]? || "white",
    tiles[north_west(pos)]? || "white",
    tiles[north_east(pos)]? || "white",
  ]
end

def permute(tiles)
  next_tiles = {} of Vec2 => String
  xs = tiles.keys.map { |v| v[0] }
  ys = tiles.keys.map { |v| v[1] }
  min_x, max_x = xs.min, xs.max
  min_y, max_y = ys.min, ys.max

  (min_x - 2..max_x + 2).each do |x|
    (min_y - 2..max_y + 2).each do |y|
      p = {x, y}
      neighbors = get_neighbors(tiles, p)
      black_neighbors = neighbors.select("black")
      if tiles[p]? == "black" && (black_neighbors.size == 0 || black_neighbors.size > 2)
      elsif tiles[p]?.nil? && black_neighbors.size == 2
        next_tiles[p] = "black"
      elsif tiles[p]? == "black"
        next_tiles[p] = "black"
      end
    end
  end

  next_tiles
end

tiles = {} of Vec2 => String

instructions = File.read_lines(ARGV.first? || "./day_24.txt")

instructions.each do |inst|
  pos = {0, 0}
  until inst.empty?
    case {inst[0], inst[1]?}
    when {'e', _}
      pos = east(pos)
      inst = inst[1..]
    when {'s', 'e'}
      pos = south_east(pos)
      inst = inst[2..]
    when {'s', 'w'}
      pos = south_west(pos)
      inst = inst[2..]
    when {'w', _}
      pos = west(pos)
      inst = inst[1..]
    when {'n', 'w'}
      pos = north_west(pos)
      inst = inst[2..]
    when {'n', 'e'}
      pos = north_east(pos)
      inst = inst[2..]
    end
  end
  if tiles[pos]?
    tiles.delete(pos)
  else
    tiles[pos] = "black"
  end
end

puts "part 1: #{tiles.values.select("black").size}"

100.times do |d|
  tiles = permute(tiles)
  puts "day #{d}: #{tiles.values.select("black").size}"
end

puts "part 2: #{tiles.values.select("black").size}"
