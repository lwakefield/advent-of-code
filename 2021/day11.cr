# Sat Dec 11 08:51:49 EST 2021

input_lights = STDIN.gets_to_end.lines.map do |line|
  line.chars.map(&.to_i32)
end

def neighbors(x, y)
  [
    {x-1,y-1},
    {x  ,y-1},
    {x+1,y-1},
    {x-1,y  },
    {x+1,y  },
    {x-1,y+1},
    {x  ,y+1},
    {x+1,y+1},
  ]
end

def bound(list, w, h)
  list.select do |x, y|
    x >= 0 && x < w && y >= 0 && y < h
  end
end

def tick (lights)
  next_lights = lights.dup.map(&.dup)

  to_flash = [] of Tuple(Int32,Int32)
  lights.each_with_index do |row, y|
    row.each_with_index do |v, x|
      next_lights[y][x] += 1

      to_flash << {x,y} if next_lights[y][x] > 9
    end
  end

  flashed = Set(Tuple(Int32, Int32)).new
  w, h = lights[0].size, lights.size

  until to_flash.empty?
    x, y = to_flash.pop

    next if flashed.includes?({x, y})

    flashed.add({x, y})

    bound(neighbors(x, y), w, h).each do |x, y|
      next_lights[y][x] += 1

      next if flashed.includes?({x, y})

      to_flash << {x, y} if next_lights[y][x] > 9
    end
  end

  flashed.each do |x, y|
    next_lights[y][x] = 0
  end

  next_lights
end

# puts tick(
# "11111
# 19991
# 19191
# 19991
# 11111".lines.map(&.chars.map(&.to_i32))
# )
# exit 1

lights = input_lights.dup.map(&.dup)
flashes = 0
puts lights.map(&.join(",")).join("\n")
100.times do
  lights = tick lights
  # puts "-"*10
  # puts lights.map(&.join(",")).join("\n")
  flashes += lights.flatten.select{|v| v==0}.size
end

puts "Part 1: #{flashes}"

# Sat Dec 11 09:46:53 EST 2021

lights = input_lights.dup.map(&.dup)
count = 0
loop do
  count += 1
  lights = tick lights
  puts "step #{count}".ljust(10,'-')
  puts lights.map(&.join(",")).join("\n")
  if lights.flatten.all?{|v| v==0 }
    puts "Part 2: #{count}"
    break
  end
end

# Sat Dec 11 09:52:19 EST 2021
