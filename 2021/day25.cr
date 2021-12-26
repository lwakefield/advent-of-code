map = [] of Array(Char)
STDIN.gets_to_end.lines.each do |line|
  map << line.chars
end

def tick (map)
  w = map.first.size
  h = map.size

  has_changed = false

  next_map = map.clone

  (h-1).to(0).each do |y|
    (w-1).to(0).each do |x|
      # puts "#{x},#{y}"
      next unless map[y][x] == '.'
      next unless map[y][x-1] == '>'
      next_map[y][x] = '>'
      next_map[y][x-1] = '.'
      has_changed = true
    end
  end

  map, next_map = next_map, next_map.clone

  (h-1).to(0).each do |y|
    (w-1).to(0).each do |x|
      next unless map[y][x] == '.'
      next unless map[y-1][x] == 'v'
      next_map[y][x] = 'v'
      next_map[y-1][x] = '.'
      has_changed = true
    end
  end

  { has_changed, next_map }
end


count = 0
loop do
  count += 1
  has_changed, map = tick(map)
  break if !has_changed
end

puts "part 1: #{count}"
