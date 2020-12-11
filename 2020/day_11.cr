require "./grid.cr"

lines = File.read_lines("./day_11.txt")
grid = Grid(Char).new(lines.first.size, lines.size) do |x, y|
  lines[y][x]
end

class Grid(T)
  def neighbors(x, y)
    [
      self[x - 1, y - 1]?,
      self[x, y - 1]?,
      self[x + 1, y - 1]?,
      self[x - 1, y]?,
      self[x + 1, y]?,
      self[x - 1, y + 1]?,
      self[x, y + 1]?,
      self[x + 1, y + 1]?,
    ].compact
  end

  protected def grid
    @grid
  end

  def ==(grid)
    @grid == grid.grid
  end
end

def first_neighbor_in_dir (grid, pos, dir)
      x, y = pos[0] + dir[0], pos[1] + dir[1]
      while grid[x, y]?
          return grid[x, y] if grid[x, y] != '.'
          x += dir[0]
          y += dir[1]
      end
      nil
end
def first_neighbor_in_all_dirs (grid, pos)
    [
      first_neighbor_in_dir(grid, pos, {-1, -1}),
      first_neighbor_in_dir(grid, pos, { 0, -1}),
      first_neighbor_in_dir(grid, pos, {+1, -1}),
      first_neighbor_in_dir(grid, pos, {-1,  0}),
      first_neighbor_in_dir(grid, pos, {+1,  0}),
      first_neighbor_in_dir(grid, pos, {-1, +1}),
      first_neighbor_in_dir(grid, pos, { 0, +1}),
      first_neighbor_in_dir(grid, pos, {+1, +1}),
    ].compact
end

def tick_1(grid)
  next_grid = grid.clone
  grid.each do |x, y, v|
    if v == 'L' && grid.neighbors(x, y).select('#').size == 0
      next_grid[x, y] = '#'
    elsif v == '#' && grid.neighbors(x, y).select('#').size >= 4
      next_grid[x, y] = 'L'
    end
  end
  next_grid
end

def tick_2(grid)
  next_grid = grid.clone
  grid.each do |x, y, v|
    if v == 'L' && first_neighbor_in_all_dirs(grid, {x, y}).select('#').size == 0
      next_grid[x, y] = '#'
    elsif v == '#' && first_neighbor_in_all_dirs(grid, {x, y}).select('#').size >= 5
      next_grid[x, y] = 'L'
    end
  end
  next_grid
end

# part 1
# ======

# last_grid = nil
# curr_grid = grid
# until last_grid == curr_grid
#   last_grid = curr_grid
#   curr_grid = tick_1(curr_grid)
# end

# seat_count = 0
# curr_grid.each do |x, y, v|
#   seat_count += 1 if v == '#'
# end
# puts seat_count

# part 2
# ======

last_grid = nil
curr_grid = grid
until last_grid == curr_grid
  last_grid = curr_grid
  STDOUT << "."
  curr_grid = tick_2(curr_grid)
end

seat_count = 0
curr_grid.each do |x, y, v|
  seat_count += 1 if v == '#'
end
puts seat_count
