steps = (File.read ARGV.first).split(",").map(&.strip)

def hash(s : String)
    s.chars.reduce(0) do |acc, i|
        acc += i.ord
        acc *= 17
        acc %= 256
        acc
    end
end

puts "Part 1: #{steps.map do |s|
        hash s
end.sum}"

hashmap = {} of Int32 => Array(Tuple(String, String))
steps.each do |s|
    _, a, b, c = (s.match /(\w+)(-|=)(\d*)/).not_nil!
    h = hash a
    case b
    when "=" then
        hashmap[h] ||= [] of Tuple(String, String)
        if i = hashmap[h].index{|aa,cc| aa==a}
            hashmap[h][i] = {a, c}
        else
            hashmap[h] << {a, c}
        end
    when "-" then
        next unless hashmap[h]?
        hashmap[h].reject!{|aa,cc| aa==a}
    else raise "err"
    end
end

puts "Part 2: #{hashmap.map do |i, lenses|
    lenses.map_with_index do |p, j|
        (i+1) * (j+1) * (p[1].to_i)
    end
end.flatten.sum}"
