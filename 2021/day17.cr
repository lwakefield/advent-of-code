# Sat Dec 18 07:40:44 EST 2021
# Sat Dec 18 07:54:13 EST 2021
# Sat Dec 18 08:24:28 EST 2021

alias Vec2 = Tuple(Int32,Int32)

def in_bounds?(p, bounds)
  bounds[0].includes?(p[0]) &&
    bounds[1].includes?(p[1])
end

def find_paths(target)
  x_target, y_target = target

  vx_range = 0..x_target.end
  vy_range = y_target.begin..y_target.begin.abs

  paths = [] of Array(Vec2)
  vx_range.each do |svx|
    vy_range.each do |svy|
      vx, vy = svx, svy
      path = [{0,0}] of Vec2
      while path.last[0] < x_target.end && path.last[1] > y_target.begin
        x, y = path.last
        path << { x+vx, y+vy }

        if in_bounds? path.last, target
          paths << path
          break
        end

        vx = Math.max(vx-1,0)
        vy -= 1
      end
    end
  end

  paths
end

def part1(target)
  find_paths(target).map do |p|
    p.map(&.[1]).max
  end.max
end

# puts("part 1: #{part1({20..30, -10..-5})}")
puts("part 1: #{part1({124..174, -123..-86})}")
# puts("part 2: #{find_paths({20..30, -10..-5}).size}")
puts("part 2: #{find_paths({124..174, -123..-86}).size}")
