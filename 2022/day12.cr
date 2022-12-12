map = STDIN.gets_to_end.lines.map(&.chars)

start_pos, stop_pos = nil, nil
map.each_with_index do |r, y|
  r.each_with_index do |c, x|
    start_pos = {x, y} if c == 'S'
    stop_pos =  {x, y} if c == 'E'
  end
end
raise "err" unless start_pos && stop_pos
map[start_pos[1]][start_pos[0]] = 'a'
map[stop_pos[1]][stop_pos[0]] = 'z'

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
  def initialize (@m : Array(Array(Char)))
  end
  def heuristic (start : Pos, goal : Pos)
    d = 1
    d2 = 1
    dx = (start[0] - goal[0]).abs
    dy = (start[1] - goal[1]).abs
    d * (dx + dy) + (d2 - 2 * d) * Math.min(dx,dy)
  end
  def neighbors (p : Pos)
    [{1,0}, {-1,0}, {0,1}, {0,-1}].each do |dx, dy|
      x, y = p[0] + dx, p[1] + dy
      next if x < 0 || x >= @m.first.size || y < 0 || y >= @m.size
      next if (@m[y][x].ord - @m[p[1]][p[0]].ord) > 1
      yield({x, y})
    end

  end
  def move_cost (a : Pos, b : Pos)
    1
  end
end
path = AStar.a_star(start_pos, stop_pos, Graph.new(map))
puts "part 1: #{path.size-1}"

soln = nil
map.each_with_index do |r, y|
  r.each_with_index do |c, x|
    next unless c == 'a'

    begin
      path = AStar.a_star({x,y}, stop_pos, Graph.new(map))
      if !soln
        soln = path
      else
        soln = path if path.size < soln.size
      end
    rescue e
    end
  end
end
puts "part 2: #{soln.not_nil!.size-1}"
