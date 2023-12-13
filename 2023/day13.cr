maps = File.read(ARGV.first).split(/(?<=\n)\n/)

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

def get_size (map)
    w = map.index(/\n/).not_nil!
    h = map.scan(/\n/).size
    {w,h}
end

def get_mirror_y (m)
    w, h = get_size m
    (1...h).each do |i|
        t, b = m.lines[0...i], m.lines[i..]
        if t.size > b.size
            t = t[-b.size..]
        elsif b.size > t.size
            b = b[...t.size]
        end
        # puts i
        # puts t, b
        return i if t.reverse == b
    end
    nil
end

def get_mirror_x (m)
    get_mirror_y rot90(m)
end

def get_mirror (m)
    if y=get_mirror_y(m)
        return y*100
    elsif x=get_mirror_x(m)
        return x
    end
    nil
end

puts "Part 1: #{maps.map{|m| get_mirror(m).not_nil!}.sum}"

def get_mirror_y2 (m)
    w, h = get_size m
    res = [] of Int32
    (1...h).each do |i|
        t, b = m.lines[0...i], m.lines[i..]
        if t.size > b.size
            t = t[-b.size..]
        elsif b.size > t.size
            b = b[...t.size]
        end
        res << i if t.reverse == b
    end
    res
end

def get_mirror_x2 (m)
    get_mirror_y2 rot90(m)
end

def get_mirror2 (m)
    return get_mirror_y2(m).map{|v|v*100} + get_mirror_x2(m)
end


def find_smudge (m)
    w, h = get_size m
    old_mp = get_mirror(m)
    (0...m.size).each do |i|
        # puts i
        next if m[i] == '\n'
        # puts m.sub(i, m[i] == '#' ? '.' : '#')
        mp = get_mirror2(m.sub(i, m[i] == '#' ? '.' : '#')).reject(old_mp).first?
        return mp if mp
        # return mp if mp && mp != old_mp
    end
    nil
end

puts(find_smudge(maps[0]))
puts(find_smudge(maps[1]))

puts "Part 2: #{maps.map{|m| find_smudge(m).not_nil!}.sum}"
