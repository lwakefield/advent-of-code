# Sun Dec 19 08:14:00 EST 2021

alias Vec3 = Tuple(Int32,Int32,Int32)
scans = STDIN.gets_to_end.split("\n\n").map do |scanner|
  scanner.lines[1..].map do |line|
    x,y,z = line.split(',').map(&.to_i32)
    Vec3.new(x,y,z)
  end
end

def scan_orientations (scan)
  o = scan.map { |p| orientations p }
  (0..23).map do |i|
    o.map(&.[i])
  end
end

def overlay (a, a_at, b, b_at)
  ax,ay,az = a_at
  bx,by,bz = b_at
  dx,dy,dz = bx-ax,by-ay,bz-az
  b.map do |p|
    x,y,z = p
    {x-dx,y-dy,z-dz}
  end.to_set & a.to_set
end

def mat_mul(a,b)
  tpos_b = b.transpose
  a.map do |aa|
    tpos_b.map do |bb|
      aa.zip(bb).map do |x,y|
        x*y
      end.sum
    end
  end
end

def rot_x(v : Vec3, d)
  rot_x([[v[0].to_f64],[v[1].to_f64],[v[2].to_f64]], d)
end
def rot_x(v, d)
  mat_mul(
    [[1f64, 0f64,        0f64],
     [0f64, Math.cos(d), -Math.sin(d)],
     [0f64, Math.sin(d), Math.cos(d)]], v)
end

def rot_y(v : Vec3, d)
  rot_y([[v[0].to_f64],[v[1].to_f64],[v[2].to_f64]], d)
end
def rot_y(v, d)
  mat_mul(
    [[Math.cos(d),  0,    Math.sin(d)],
     [0f64,         1f64, 0f64],
     [-Math.sin(d), 0f64, Math.cos(d)]], v)
end

def rot_z(v : Vec3, d)
  rot_z([[v[0].to_f64],[v[1].to_f64],[v[2].to_f64]], d)
end
def rot_z(v, d)
  mat_mul(
    [[Math.cos(d), -Math.sin(d), 0],
     [Math.sin(d), Math.cos(d),  0],
     [0f64,        0f64,         1f64]], v)
end

def orientations (v)
  [
    Vec3.from(rot_x(v, 0*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(v, 1*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(v, 2*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(v, 3*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 1*Math::PI/2), 0*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 1*Math::PI/2), 1*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 1*Math::PI/2), 2*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 1*Math::PI/2), 3*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(rot_y(v, 2*Math::PI/2), 0*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(rot_y(v, 2*Math::PI/2), 1*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(rot_y(v, 2*Math::PI/2), 2*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_x(rot_y(v, 2*Math::PI/2), 3*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 3*Math::PI/2), 0*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 3*Math::PI/2), 1*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 3*Math::PI/2), 2*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_z(rot_y(v, 3*Math::PI/2), 3*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 1*Math::PI/2), 0*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 1*Math::PI/2), 1*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 1*Math::PI/2), 2*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 1*Math::PI/2), 3*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 3*Math::PI/2), 0*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 3*Math::PI/2), 1*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 3*Math::PI/2), 2*Math::PI/2).flatten.map(&.round_away.to_i32)),
    Vec3.from(rot_y(rot_z(v, 3*Math::PI/2), 3*Math::PI/2).flatten.map(&.round_away.to_i32)),
  ]
end

def get_overlay (a, b)
  scan_orientations(b).each do |b|
    a.each do |ap|
      b.each do |bp|
        if overlay(a, ap, b, bp).size >= 12
          ax,ay,az=ap
          bx,by,bz=bp
          dx,dy,dz=ax-bx,ay-by,az-bz
          return { b, {dx,dy,dz} }
        end
      end
    end
  end
  nil
end

a, b = scans[0], scans[1]

found = scans[0].dup
to_find = scans[1..]
scanner_locations = [{0,0,0}]
until to_find.empty?
  puts to_find.size
  to_find.each do |f|
    if (o = get_overlay(found, f))
      oriented, offset = o
      dx,dy,dz = offset

      scanner_locations << offset

      found += oriented.map { |x,y,z| {x+dx,y+dy,z+dz} }

      found.uniq!

      to_find.delete(f)
      break
    end
  end
end

pp found.tally.size

pp(scanner_locations.combinations(2).map do |pair|
  a, b = pair
  ax,ay,az = a
  bx,by,bz = b

  (ax-bx).abs + (ay-by).abs + (az-bz).abs
end.max)

# Sun Dec 19 17:41:15 EST 2021
