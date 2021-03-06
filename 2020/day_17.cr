alias Vec4 = Tuple(Int32, Int32, Int32, Int32)
alias World = Hash(Vec4, Char)

def bounds(world)
  x = world.keys.map { |v| v[0] }
  y = world.keys.map { |v| v[1] }
  z = world.keys.map { |v| v[2] }
  w = world.keys.map { |v| v[3] }

  [
    {x.min, y.min, z.min, w.min},
    {x.max, y.max, z.max, w.max},
  ]
end

def add(a, b)
  {a[0] + b[0], a[1] + b[1], a[2] + b[2], a[3] + b[3]}
end

def neighbors(pos, world)
  res = [] of Char | Nil
  (-1..+1).each do |x|
    (-1..+1).each do |y|
      (-1..+1).each do |z|
        (-1..+1).each do |w|
          next if {x, y, z, w} == {0, 0, 0, 0}
          res << world[add(pos, {x, y, z, w})]?
        end
      end
    end
  end
  res.compact
end

def tick(world)
  next_world = World.new
  min, max = bounds(world)
  (min[0] - 1..max[0] + 1).each do |x|
    (min[1] - 1..max[1] + 1).each do |y|
      (min[2] - 1..max[2] + 1).each do |z|
        (min[3] - 1..max[3] + 1).each do |w|
          pos = {x, y, z, w}
          if world[pos]? && [2, 3].includes?(neighbors(pos, world).size)
            next_world[pos] = '#'
          elsif world[pos]?.nil? && neighbors(pos, world).size == 3
            next_world[pos] = '#'
          end
        end
      end
    end
  end
  next_world
end

def print_world(world)
  min, max = bounds(world)
  puts "#{min}, #{max}"

  res = ""
  (min[2]..max[2]).each do |z|
    res += "z=#{z}\n"
    (min[1]..max[1]).each do |y|
      (min[0]..max[0]).each do |x|
        res += (world[{x, y, z}]? || '.')
      end
      res += "\n"
    end
    res += "\n"
  end
  puts res
end

lines = File.read_lines(ARGV.first? || "./day_17.txt")
world = World.new
lines.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    world[{x, y, 0, 0}] = c if c == '#'
  end
end

# puts "world:"
# print_world world
6.times do
  world = tick world
  # puts "world:"
  # print_world world
end
puts "part 2: #{world.size}"
