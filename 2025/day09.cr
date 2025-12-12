red_tiles = STDIN.gets_to_end.lines.map { |l| Tuple(Int64, Int64).from(l.split(",").map(&.to_i64)) }

def area(a, b)
  ax, ay = a
  bx, by = b
  ((bx - ax).abs + 1)*((by - ay).abs + 1)
end

largest = red_tiles.combinations(2).map do |p|
  area(p[0], p[1])
end.max
puts "part 1: #{largest}"

map = {} of Tuple(Int64, Int64) => Char
(red_tiles + [red_tiles.first]).each_cons_pair do |a, b|
  map[a] = '#'
  map[b] = '#'
  ax, ay = a
  bx, by = b
  (Math.min(ax, bx)..Math.max(ax, bx)).each do |x|
    (Math.min(ay, by)..Math.max(ay, by)).each do |y|
      map[{x, y}] ||= 'X'
    end
  end
end

def orientation (p, q, r)
  val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
  return 0 if val == 0
  return 1 if val > 0
  2
end

# a, b are top-left, bottom-right of a rect, order gets fixed
# c, d are ends of a line segment
def intersects? (a, b, c, d)
  ax, bx = {a[0],b[0]}.minmax
  ay, by = {a[1],b[1]}.minmax

  cx, dx = {c[0],d[0]}.minmax
  cy, dy = {c[1],d[1]}.minmax

  cx < bx && cy < by && dx > ax && dy > ay
end

largest = 0
red_tiles.combinations(2).each do |pair|
  a, b = pair
  is_valid = !(red_tiles + [red_tiles[0]]).each_cons_pair.any? do |c, d|
    intersects? a, b, c, d
  end
  next unless is_valid
  if (a = area(a,b)) > largest
    largest = a
  end
end
puts "part 2: #{largest}"

# It took me a while to get this one! I really wanted to _understand_ the solution, so wasn't satisfied copy-pasting code. This is the solution I finally _got_: https://www.reddit.com/r/adventofcode/comments/1phywvn/comment/nt2xpf2/. A nice little "does line segment intersect rectangle" algorithm.