map = File.read ARGV.first
w = map.index(/\n/).not_nil!
h = map.scan(/\n/).size

def rot90 (map)
    w, h = get_size map

    r = (" " * h + "\n") * w

    map.chars.each_with_index do |c, i|
        next if c == '\n'
        x = i % (w + 1)
        y = i // (w + 1)
        nx, ny = h - 1 - y, x

        # puts("#{{x,y}} -> #{{nx,ny}}")

        r = r.sub(ny * (h+1) + nx, c)
    end

    r
end

def expand (map, n)
    w, _ = get_size map
    map.gsub("."*w+"\n", ("."*w+"\n")*n)
end

def get_size (map)
    w = map.index(/\n/).not_nil!
    h = map.scan(/\n/).size
    {w,h}
end

macro get_x(i,w)
    {{ i }} % ({{ w }} + 1)
end

macro get_y(i,w)
    {{ i }} // ({{ w }} + 1)
end

def solve (map)
    w, h = get_size map
    map.scan(/#/).map(&.begin).combinations(2).map do |p|
            l, r = p
            lx, ly = get_x(l,w), get_y(l,w)
            rx, ry = get_x(r,w), get_y(r,w)
            dx, dy = (lx - rx).abs, (ly - ry).abs
            dx + dy
    end.sum
end

part_0 = solve(map)
puts "Part 0: #{part_0}"

part_1 = solve expand(rot90(expand map, 2), 2)
puts "Part 1: #{part_1}"

# expanded = rot90 rot90 rot90 expand(rot90(expand map, 3), 3)
# puts "Part 1.1: #{solve(expanded)}"

# expanded = rot90 rot90 rot90 expand(rot90(expand map, 4), 4)
# puts "Part 1.2: #{solve(expanded)}"

# conveniently, the solve expands linearly making part 2 an easy multiple

delta = (part_1 - part_0).to_u64
puts "Part 2: #{part_0.to_u64 + delta * 999_999}"
