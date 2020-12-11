def get_cell(grid, x, y)
  return nil if x < 0
  return nil if x >= grid.first.size
  return nil if y < 0
  return nil if y >= grid.size
  return grid[y][x]
end

def each_cell(grid)
  (0...grid.size).each do |y|
    (0...grid.first.size).each do |x|
      yield x, y, get_cell(grid, x, y)
    end
  end
end

def adjacent(grid, x, y)
  [
    get_cell(grid, x - 1, y - 1),
    get_cell(grid, x, y - 1),
    get_cell(grid, x + 1, y - 1),
    get_cell(grid, x - 1, y),
    get_cell(grid, x + 1, y),
    get_cell(grid, x - 1, y + 1),
    get_cell(grid, x, y + 1),
    get_cell(grid, x + 1, y + 1),
  ].compact
end

def tick_1(grid)
  next_grid = grid.clone
  each_cell(grid) do |x, y, v|
    if v == 'L' && adjacent(grid, x, y).select('#').empty?
      next_grid[y][x] = '#'
    elsif v == '#' && adjacent(grid, x, y).select('#').size >= 4
      next_grid[y][x] = 'L'
    end
  end
  next_grid
end

def raycast(grid, x, y, dx, dy)
    x += dx; y += dy
    while c = get_cell(grid, x, y)
        return c if c != '.'
        x += dx; y += dy
    end
    nil
end

def visible_from(grid, x, y)
    [
      raycast(grid, x, y, -1, -1),
      raycast(grid, x, y,  0, -1),
      raycast(grid, x, y, +1, -1),
      raycast(grid, x, y, -1,  0),
      raycast(grid, x, y, +1,  0),
      raycast(grid, x, y, -1, +1),
      raycast(grid, x, y,  0, +1),
      raycast(grid, x, y, +1, +1),
    ].compact
end

def tick_2(grid)
  next_grid = grid.clone
  each_cell(grid) do |x, y, v|
    if v == 'L' && visible_from(grid, x, y).select('#').empty?
      next_grid[y][x] = '#'
    elsif v == '#' && visible_from(grid, x, y).select('#').size >= 5
      next_grid[y][x] = 'L'
    end
  end
  next_grid
end

grid = File.read_lines("./day_11.txt").map(&.chars)

last_grid = nil
curr_grid = grid
until last_grid == curr_grid
  last_grid = curr_grid
  curr_grid = tick_1(curr_grid)
end
puts "part 1: #{curr_grid.flatten.select('#').size}"

last_grid = nil
curr_grid = grid
until last_grid == curr_grid
  last_grid = curr_grid
  curr_grid = tick_2(curr_grid)
end
puts "part 2: #{curr_grid.flatten.select('#').size}"
