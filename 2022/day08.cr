grid = STDIN.gets_to_end.lines.map(&.chars.map(&.to_i32))

def is_visible (x, y, grid)
  return true if x == 0
  return true if x == grid.first.size-1
  return true if y == 0
  return true if y == grid.size-1

  return true if (0...x).each.all? do |xx|
    grid[y][xx] < grid[y][x]
  end

  return true if (x+1...grid.first.size).each.all? do |xx|
    grid[y][xx] < grid[y][x]
  end

  return true if (0...y).each.all? do |yy|
    grid[yy][x] < grid[y][x]
  end

  return true if (y+1...grid.size).each.all? do |yy|
    grid[yy][x] < grid[y][x]
  end

  false
end

visible_count = 0
(0...grid.size).each do |y|
  (0...grid.first.size).each do |x|
    visible_count += 1 if is_visible(x, y, grid)
  end
end

puts "part 1: #{visible_count}"

def scenic_score (x, y, grid)
  left, right, up, down = 0, 0, 0, 0

  (0...x).reverse_each do |xx|
    left += 1
    break unless grid[y][xx] < grid[y][x]
  end

  (x+1...grid.first.size).each do |xx|
    right += 1
    break unless grid[y][xx] < grid[y][x]
  end

  (0...y).reverse_each do |yy|
    up += 1
    break unless grid[yy][x] < grid[y][x]
  end

  (y+1...grid.size).each do |yy|
    down += 1
    break unless grid[yy][x] < grid[y][x]
  end

  left * right * up * down
end

scores = [] of Int32
(0...grid.size).each do |y|
  (0...grid.first.size).each do |x|
    scores << scenic_score(x, y, grid)
  end
end
puts "part 2: #{scores.max}"
