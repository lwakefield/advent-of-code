map = STDIN.each_line.map do |line|
    line.chars
end.to_a

def get_hrz(map, x, y)
    c = map[y][x...x+4].join
    return nil if c.size != 4
    return c
end

def get_vert(map, x, y)
    c = [map.dig?(y, x), map.dig?(y+1, x), map.dig?(y+2, x), map.dig?(y+3, x)].compact.join
    return nil if c.size != 4
    return c
end

def get_diag(map, x, y)
    c = [map.dig?(y, x), map.dig?(y+1, x+1), map.dig?(y+2, x+2), map.dig?(y+3, x+3)].compact.join
    return nil if c.size != 4
    return c
end

def get_diag2(map, x, y)
    return nil if x-3 < 0
    c = [map.dig?(y, x), map.dig?(y+1, x-1), map.dig?(y+2, x-2), map.dig?(y+3, x-3)].compact.join
    return nil if c.size != 4
    return c
end

c = 0
(0...map.size).each do |y|
    (0...map.first.size).each do |x|
        cs = [
            get_hrz(map, x, y),
            get_vert(map, x, y),
            get_diag(map, x, y),
            get_diag2(map, x, y)
        ]
        c+=cs.select { |c| c == "XMAS" || c == "SAMX" }.size
    end
end
puts "Part 1: #{c}"

def get_ex(map, x, y)
    return nil if x-1<0 || y-1<0 || x+1>=map.first.size || y+1>=map.size
    a = [map.dig?(y-1, x-1), map.dig?(y, x), map.dig?(y+1, x+1)].join
    b = [map.dig?(y-1, x+1), map.dig?(y, x), map.dig?(y+1, x-1)].join
    return [a,b]
end

c=0
(0...map.size).each do |y|
    (0...map.first.size).each do |x|
        ab = get_ex(map, x, y)
        next unless ab
        a, b = ab
        c+=1 if (a == "MAS" || a == "SAM") && (b == "MAS" || b == "SAM")
    end
end
puts "Part 2: #{c}"