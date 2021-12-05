# Sun Dec  5 07:51:11 EST 2021

map = {} of Tuple(Int32, Int32) => Int32
STDIN.each_line do |line|
  left, right = line.split " -> "

  x1,y1 = left.split(",").map(&.to_i32)
  x2,y2 = right.split(",").map(&.to_i32)

  line({x1,y1}, {x2,y2}) do |x, y|
    map[{x, y}] ||= 0
    map[{x, y}] += 1
  end
end

def line (p1, p2)
  x1, y1 = p1
  x2, y2 = p2

  if (x2 - x1) == 0
    y1, y2 = y2, y1 if y2 < y1
    (y1..y2).each do |y|
      yield ({x1, y})
    end
  else
    x1, x2, y1, y2 = x2, x1, y2, y1 if x2 < x1
    m = (y2 - y1) / (x2 - x1)
    b = y1 - (m * x1)
    (x1..x2).each do |x|
      y = (m * x).to_i32 + b.to_i32
      yield ({x, y})
    end
  end
end

# line({0,0}, {10,0}) { |p| puts p }
# line({10,0}, {0,0}) { |p| puts p }
# line({0,0}, {0,10}) { |p| puts p }
# line({0,10}, {0,0}) { |p| puts p }
# line({0,0}, {10,10}) { |p| puts p }
# line({10,10}, {0,0}) { |p| puts p }
# line({0,10}, {10,0}) { |p| puts p }
# line({1,1},{3,3}) { |p| puts p }

puts "part 2: #{map.values.select{|v| v > 1}.size}"

# Sun Dec  5 07:58:44 EST 2021
# Sun Dec  5 08:30:13 EST 2021
