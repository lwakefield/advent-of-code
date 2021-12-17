# Wed Dec 15 06:48:26 EST 2021

grid = [] of Array(Int32)
STDIN.each_line do |line|
  grid << line.chars.map(&.to_i32)
end

def path_cost (path, grid)
  path.map do |x, y|
    grid[y][x]
  end.sum
end

alias Vec2 = Tuple(Int32,Int32)

def print_path(path, grid)
  bg = [] of Array(Char)
  grid.size.times do
    bg << ['.'] * grid.first.size
  end

  path.each do |x, y|
    bg[y][x] = grid[y][x].to_s.chars.first
  end

  puts bg.map(&.join).join("\n")
end

# pausing...
# Wed Dec 15 07:26:57 EST 2021
# Wed Dec 15 17:18:03 EST 2021

class AStar(Position, AStarGraph)
  def self.a_star (start : Position, goal : Position, graph : AStarGraph)
    open_set = [start].to_set
    closed_set = Set(Position).new
    came_from = {} of Position => Position
    g_score = {} of Position => Int32
    f_score = {} of Position => Int32

    g_score[start] = 0
    f_score[start] = graph.heuristic(start, goal)

    until open_set.empty?
      current = nil
      current_f_score = nil
      open_set.each do |v|
        if current.nil? || f_score[v] < current_f_score.not_nil!
          current_f_score = f_score[v]
          current = v
        end
      end

      if current == goal
        path = [current.not_nil!]
        while came_from[current]?
          current = came_from[current]
          path << current.not_nil!
        end
        return path.reverse
      end

      open_set.delete current
      closed_set << current.not_nil!

      graph.neighbors(current.not_nil!) do |n|
        next if closed_set.includes? n

        candidate_g = g_score[current] + graph.move_cost(current.not_nil!, n)

        if !open_set.includes? n
          open_set << n
        elsif candidate_g >= g_score[n]
          next
        end

        came_from[n] = current.not_nil!
        g_score[n] = candidate_g
        h = graph.heuristic(n, goal)
        f_score[n] = g_score[n] + h
      end
    end
    raise "could not find solution"
  end
end

class Graph
  def initialize (@m : Array(Array(Int32)))
  end
  def heuristic (start : Vec2, goal : Vec2)
    dx = (start[0] - goal[0]).abs
    dy = (start[1] - goal[1]).abs
    dx + dy
  end
  def neighbors (p : Vec2)
    [{1,0}, {-1,0}, {0,1}, {0,-1}].each do |dx, dy|
      x, y = p[0] + dx, p[1] + dy
      next if x < 0 || x >= @m.first.size || y < 0 || y >= @m.size
      yield({x, y})
    end

  end
  def move_cost (a : Vec2, b : Vec2)
    return @m[b[1]][b[0]]
  end
end

to = { grid.first.size - 1, grid.size - 1 }
start = {0,0}
path = AStar.a_star(start, to, Graph.new(grid))
puts "part 1"
# puts "------"
# print_path(path, grid)
puts "cost: #{path_cost path[1..], grid }"

# Wed Dec 15 18:09:35 EST 2021
# Wed Dec 15 18:21:19 EST 2021

# Fri Dec 17 09:49:44 EST 2021
big_grid = (0...5*grid.size).map do |y|
  (0...5*grid.size).map do |x|
    grid_x, grid_y = x // grid.size, y // grid.first.size

    num = grid[y % grid.size][x % grid.first.size]
    num += grid_x + grid_y
    num = 1 + (num-1)%9
    num
  end
end
to = { big_grid.first.size - 1, big_grid.size - 1 }
start = {0,0}
path = AStar.a_star(start, to, Graph.new(big_grid))
puts "part 2"
# puts "------"
# print_path(path, grid)
puts "cost: #{path_cost path[1..], big_grid }"
# Fri Dec 17 09:59:51 EST 2021


