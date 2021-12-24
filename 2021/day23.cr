
alias Vec2 = Tuple(Int32,Int32)
def to_map (input)
  map = {} of Vec2 => Char
  input.lines.each_with_index do |line, y|
    line.chars.each_with_index do |c, x|
      map[{x,y}] = c
    end
  end
  map
end

def solved? (map)
  if map[{0,6}]?
    return [{3,5}, {3,4}, {3,3}, {3,2}].all?{|p| map[p]=='A'} &&
           [{5,5}, {5,4}, {5,3}, {5,2}].all?{|p| map[p]=='B'} &&
           [{7,5}, {7,4}, {7,3}, {7,2}].all?{|p| map[p]=='C'} &&
           [{9,5}, {9,4}, {9,3}, {9,2}].all?{|p| map[p]=='D'}
  elsif map[{0,4}]?
    return [{3,3}, {3,2}].all?{|p| map[p]=='A'} &&
           [{5,3}, {5,2}].all?{|p| map[p]=='B'} &&
           [{7,3}, {7,2}].all?{|p| map[p]=='C'} &&
           [{9,3}, {9,2}].all?{|p| map[p]=='D'}
  end
  raise "err"
end

def get_pod_locations (map, pod)
  locs = [] of Vec2
  map.each do |p, v|
      locs << p if v == pod
  end
  locs
end

def valid_hallway_options
  [
    {1, 1},
    {2, 1},
    {4, 1},
    {6, 1},
    {8, 1},
    {10, 1},
    {11, 1},
  ]
end

def target_pos (map, c)
  if map[{0,6}]?
    return [{3,5}, {3,4}, {3,3}, {3,2}] if c == 'A'
    return [{5,5}, {5,4}, {5,3}, {5,2}] if c == 'B'
    return [{7,5}, {7,4}, {7,3}, {7,2}] if c == 'C'
    return [{9,5}, {9,4}, {9,3}, {9,2}] if c == 'D'
  elsif map[{0,4}]?
    return [{3,3}, {3,2}] if c == 'A'
    return [{5,3}, {5,2}] if c == 'B'
    return [{7,3}, {7,2}] if c == 'C'
    return [{9,3}, {9,2}] if c == 'D'
  end
  raise "err"
end

def clear_path? (from, to, map)
  fx, fy = from
  tx, ty = to

  if fy > ty # in burrow, going to hallway
    (fy-1).to(ty).each do |y|
      return false if map[{fx,y}] != '.'
    end
    fx.to(tx).each do |x|
      return false if map[{x,ty}] != '.'
    end
  elsif fy < ty # in hallway going to burrow
    if fx < tx
      (fx+1).to(tx).each do |x|
        return false if map[{x,fy}] != '.'
      end
      (fy).to(ty).each do |y|
        return false if map[{tx,y}] != '.'
      end
    elsif fx > tx
      (fx-1).to(tx).each do |x|
        return false if map[{x,fy}] != '.'
      end
      (fy).to(ty).each do |y|
        return false if map[{tx,y}] != '.'
      end
    else
      raise "err"
    end
  else
    raise "err"
  end

  true
end

def in_hallway? (pos)
  valid_hallway_options.includes? pos
end

def options (map)
  options = [] of Tuple(Vec2, Vec2) # from, to

  # a. if in hall
  # b. if in wrong burrow
  # c. if in right burrow, but burrow isn't full
  # d. if in right burrow and burrow is correctly full
  # b and c are functionally the same -> move into hallway

  ['A', 'B', 'C', 'D'].each do |a|
    targets = target_pos(map, a)

    get_pod_locations(map, a).each do |p|
      i = targets.index(p)
      next if i && targets[0..i].all?{|t| map[t] == a}

      if in_hallway?(p)
        if targets.all?{|t| map[t]=='.' || map[t]==a}
          t = targets.select{|t| map[t]=='.'}

          options << {p, t[0]} if clear_path?(p, t[0], map) unless t.empty?
        end
      else
        valid_hallway_options.select{|t| clear_path?(p, t, map)}.each do |t|
          options << { p, t }
        end
      end
    end
  end

  options
end

def cost (c)
  return 1 if c == 'A'
  return 10 if c == 'B'
  return 100 if c == 'C'
  return 1000 if c == 'D'
  raise "err"
end

def serialize(map)
  map.keys.sort do |a,b|
    if a[0] <=> b[0]
      a[0] <=> b[0]
    else
      a[1] <=> b[1]
    end
  end.map{|k| map[k]}.join
end

def solve (map, soln_cache = {} of String => Int32|Nil): Int32 | Nil
  id = serialize map
  if s = soln_cache[id]?
    return s
  end
  if solved? map
    soln_cache[id] = 0
    return 0
  end

  scores = options(map).map do |from, to|
    d = cost(map[from]) * ((from[0]-to[0]).abs + (from[1]-to[1]).abs)
    next_map = map.dup
    next_map[to] = next_map[from]
    next_map[from] = '.'

    if s = solve(next_map, soln_cache)
      d + s
    else
      nil
    end
  end.compact

  s = if scores.empty?
        nil
      else
        scores.min
      end
  soln_cache[id] = s
  s
end

puts solve(to_map "
#############
#...........#
###B#B#D#A###
  #D#C#A#C#
  #########
".strip
)

puts solve(to_map "
#############
#...........#
###B#B#D#A###
  #D#C#B#A#
  #D#B#A#C#
  #D#C#A#C#
  #########
".strip
)
