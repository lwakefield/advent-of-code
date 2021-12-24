require "big"

alias Vec3 = Tuple(Int32,Int32,Int32)
alias Cube = Tuple(Range(Int32,Int32), Range(Int32,Int32), Range(Int32,Int32))


def valid? (a)
  x, y, z = a
  x.begin <= x.end && y.begin <= y.end && z.begin <= z.end
end

def intersect (a, b)
  ax, ay, az = a
  bx, by, bz = b

  {
    [ax.begin, bx.begin].max..[ax.end,   bx.end].min,
    [ay.begin, by.begin].max..[ay.end,   by.end].min,
    [az.begin, bz.begin].max..[az.end,   bz.end].min,
  }
end

def intersects? (a, b)
  valid? intersect(a, b)
end

def decimate (a, b)
  ax, ay, az = a
  bx, by, bz = b

  xs = [ax.begin, ax.end, bx.begin, bx.end].sort
  ys = [ay.begin, ay.end, by.begin, by.end].sort
  zs = [az.begin, az.end, bz.begin, bz.end].sort

  xs = [xs[0]..(xs[1]-1), xs[1]..xs[2], (xs[2]+1)..xs[3]]
  ys = [ys[0]..(ys[1]-1), ys[1]..ys[2], (ys[2]+1)..ys[3]]
  zs = [zs[0]..(zs[1]-1), zs[1]..zs[2], (zs[2]+1)..zs[3]]

  xs.map do |x|
    ys.map do |y|
      zs.map do |z|
        { x, y, z }
      end
    end
  end.flatten
end

def reboot (instructions)
  cubes = {} of Cube => Bool
  instructions.each_with_index do |line, i|
    state, rest = line.split(' ')
    state = state == "on"
    x, y, z = rest.split(",")
    xmin, xmax = x.gsub("x=", "").split("..").map(&.to_i32)
    ymin, ymax = y.gsub("y=", "").split("..").map(&.to_i32)
    zmin, zmax = z.gsub("z=", "").split("..").map(&.to_i32)

    cube = { xmin..xmax, ymin..ymax, zmin..zmax }

    cubes.keys.select{ |c| intersects? cube, c }.each do |other|
      cubes.delete other
      decimate(cube, other).each do |subcube|
        cubes[subcube] = true if intersects?(subcube, other) && !intersects?(subcube, cube)
      end
    end
    cubes[cube] = true if state
  end

  cubes.keys.map do |x, y, z|
    (1+x.end-x.begin).to_big_i * (1+y.end-y.begin).to_big_i * (1+z.end-z.begin).to_big_i
  end.sum
end

instructions = STDIN.gets_to_end.lines

puts "part 1: #{reboot(instructions[0...20])}"
puts "part 2: #{reboot(instructions)}"
