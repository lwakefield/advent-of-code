require "./util.cr"

map = File.read ARGV.first

def slide_north (map)
    w, h = get_size(map)
    (0...map.size).each do |i|
        next unless map[i] == 'O'

        new_i = i
        ((i-(w+1))..0).step(-(w+1)).each do |j|
            break if map[j] == '#'
            break if map[j] == 'O'
            new_i = j
        end
        map = map.sub(i, '.').sub(new_i, 'O')
    end
    map
end

puts "Part 1: #{get_weight(slide_north(map))}"

def spin(map)
    map = slide_north(map)
    map = slide_north rot90(map)
    map = slide_north rot90(map)
    map = slide_north rot90(map)
    rot90(map)
end

def get_weight(m)
    m.lines.reverse.map_with_index do |l, i|
        l.chars.select('O').size * (i+1)
    end.sum
end

m = nil
r = [map] of String
1_000_000_000.times do |i|
    m = spin(r.last.dup)
    if r.includes? m
        si = (1_000_000_000 - r.index(m).not_nil!) % (i - r.index(m).not_nil! + 1)
        m = r[r.index(m).not_nil! + si]
        break
    end
    r << m
end

puts "Part 2: #{get_weight(m.not_nil!)}"
