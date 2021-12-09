# Thu Dec  9 06:31:16 EST 2021

grid = ARGF.read.split("\n").map do |line|
  line.chars.map { |x| x.to_i }
end

def get_cell (grid, x, y)
  return nil if y < 0 || y >= grid.size
  return nil if x < 0 || x >= grid.first.size
  grid[y][x]
end

low_points = []
grid.each_with_index do |row, y|
  row.each_with_index do |v, x|
    up    = get_cell(grid, x, y-1)
    down  = get_cell(grid, x, y+1)
    left  = get_cell(grid, x-1, y)
    right = get_cell(grid, x+1, y)

    if [up, down, left, right].compact.all? { |v2| v2 > v }
      low_points << [x, y]
    end
  end
end

puts "part 1: #{low_points.map do |p|
    x, y = p
    grid[y][x] + 1
end.sum}"

# Thu Dec  9 06:43:27 EST 2021

def get_basin (grid, low_point)
  points = [low_point]
  to_visit = [low_point]
  visited = {}
  visited["#{low_point[0]},#{low_point[1]}"] = true

  until to_visit.empty? do
    x, y = to_visit.pop

    up    = get_cell(grid, x, y-1)
    down  = get_cell(grid, x, y+1)
    left  = get_cell(grid, x-1, y)
    right = get_cell(grid, x+1, y)

    if up && up != 9 && up > grid[y][x] && visited["#{x},#{y-1}"].nil?
      points << [x, y-1]
      to_visit << [x, y-1]
      visited["#{x},#{y-1}"] = true
    end
    if down && down != 9 && down > grid[y][x] && visited["#{x},#{y+1}"].nil?
      points << [x, y+1]
      to_visit << [x, y+1]
      visited["#{x},#{y+1}"] = true
    end
    if left && left != 9 && left > grid[y][x] && visited["#{x-1},#{y}"].nil?
      points << [x-1, y]
      to_visit << [x-1, y]
      visited["#{x-1},#{y}"] = true
    end
    if right && right !=9 && right > grid[y][x] && visited["#{x+1},#{y}"].nil?
      points << [x+1, y]
      to_visit << [x+1, y]
      visited["#{x+1},#{y}"] = true
    end
  end

  points
end

basins = low_points.map do |p|
  get_basin(grid, p)
end

pp low_points[2]
pp basins[2]

a, b, c = basins.map(&:size).sort.reverse[0..2]
puts a, b, c
puts "part 2: #{a * b * c}"

# Thu Dec  9 07:18:16 EST 2021
