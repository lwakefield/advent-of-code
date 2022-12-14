alias Pos = Tuple(Int32,Int32)
map = {} of Pos => Char

paths = STDIN.gets_to_end.lines.map do |l|
  l.split(" -> ").map do |p|
    Tuple(Int32,Int32).from p.split(",").map(&.to_i)
  end
end.each do |path|
  path.each_cons(2) do |p|
    l, r = p
    x0, x1 = [l[0], r[0]].sort
    y0, y1 = [l[1], r[1]].sort

    (x0..x1).each do |x|
      (y0..y1).each do |y|
        map[{x,y}] = '#'
      end
    end
  end
end

def add (a,b)
  {a[0]+b[0], a[1]+b[1]}
end

max_y = map.keys.map(&.[1]).max
found_the_abyss = false
until found_the_abyss
  down       = {0, 1}
  down_left  = {-1, 1}
  down_right = {+1, 1}

  p = {500, 0}
  rested = false
  until p[1] >= max_y || rested
    down       = add(p, {+0, 1})
    down_left  = add(p, {-1, 1})
    down_right = add(p, {+1, 1})
    if map[down]?.nil?
      p = down
    elsif map[down_left]?.nil?
      p = down_left
    elsif map[down_right]?.nil?
      p = down_right
    else
      rested = true
    end
  end

  if rested
    map[p] = 'o'
  else
    found_the_abyss = true
  end
end

puts "part 1: #{map.values.select('o').size}"

max_y = map.keys.map(&.[1]).max + 1
source_blocked = false
until source_blocked
  down       = {0, 1}
  down_left  = {-1, 1}
  down_right = {+1, 1}

  p = {500, 0}
  rested = false
  until p[1] >= max_y || rested
    down       = add(p, {+0, 1})
    down_left  = add(p, {-1, 1})
    down_right = add(p, {+1, 1})
    if map[down]?.nil?
      p = down
    elsif map[down_left]?.nil?
      p = down_left
    elsif map[down_right]?.nil?
      p = down_right
    else
      rested = true
    end
  end

  if p == {500,0}
    source_blocked = true
  else
    map[p] = 'o'
  end
end

puts "part 2: #{map.values.select('o').size + 1}"
