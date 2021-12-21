
# Mon Dec 20 06:21:05 EST 2021

def read_pixel(image_map, p, d='.')
  x, y = p
  c = { '.' => 0, '#' => 1 }
  [
    c[image_map.fetch({x-1, y-1}, d)],
    c[image_map.fetch({x,   y-1}, d)],
    c[image_map.fetch({x+1, y-1}, d)],
    c[image_map.fetch({x-1, y},   d)],
    c[image_map.fetch({x,   y},   d)],
    c[image_map.fetch({x+1, y},   d)],
    c[image_map.fetch({x-1, y+1}, d)],
    c[image_map.fetch({x,   y+1}, d)],
    c[image_map.fetch({x+1, y+1}, d)],
  ].join.to_i(2)
end

def get_bounds(i)
  min_x, max_x = Int32::MAX, Int32::MIN
  min_y, max_y = Int32::MAX, Int32::MIN
  i.keys.each do |x, y|
    min_x = x if x < min_x
    max_x = x if x > max_x
    min_y = y if x < min_y
    max_y = y if x > max_y
  end
  { min_x, max_x, min_y, max_y }
end

def enhance(i, a, d='.')
  minx, maxx, miny, maxy = get_bounds(i)
  minx -= 1
  miny -= 1
  maxx += 1
  maxy += 1

  new_image = {} of Vec2 => Char
  (miny..maxy).map do |y|
    (minx..maxx).map do |x|
      v = read_pixel(i, {x,y}, d)
        new_image[{x,y}] = a[v]
    end
  end

  new_image
end

def enhancen(i, a, n)
  odd = a[0]
  even = if odd == '.'
          a[0]
        else
          a[-1]
        end
  pp even, odd
  n.times do |nn|
    i = if nn == 0
          enhance(i, a, '.')
        elsif nn.even?
          enhance(i, a, even)
        else
          enhance(i, a, odd)
        end
  end
  i
end

def print_image(i)
  minx, maxx, miny, maxy = get_bounds(i)
  (miny..maxy).map do |y|
    (minx..maxx).map do |x|
      i[{x,y}]
    end.join
  end.join "\n"
end

algorithm, image = STDIN.gets_to_end.split("\n\n")
alias Vec2 = Tuple(Int32,Int32)
image_map = {} of Vec2 => Char
image.lines.each_with_index do |r, y|
  r.chars.each_with_index do |v, x|
    image_map[{x,y}] = v
  end
end

puts "part 1: #{enhancen(image_map, algorithm, 2).values.tally['#']}"
puts "part 2: #{enhancen(image_map, algorithm, 50).values.tally['#']}"
