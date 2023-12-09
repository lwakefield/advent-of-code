histories = (File.read ARGV.first).lines.map(&.split.map(&.to_i))

def get_deltas (history)
    r = [history]
    until r.last.all?{|v|v==0}
        r << r.last.each_cons(2).map do |pair|
            pair[1] - pair[0]
        end.to_a
    end
    r
end

def extrapolate (deltas)
    deltas.reverse_each.reduce([] of Array(Int32)) do |acc, i|
        if acc.empty?
            acc << (i + [i.last])
        else
            acc << (i + [i.last + acc.last.last])
        end
        acc
    end.reverse
end

puts "Part 1: #{histories.map{|h|extrapolate(get_deltas h).first.last}.sum}"

def get_deltas_bwd (history)
    r = [history]
    until r.last.all?{|v|v==0}
        r << r.last.reverse.each_cons(2).map do |pair|
            pair[1] - pair[0]
        end.to_a.reverse
    end
    r
end

def extrapolate_bwd (deltas)
    deltas.reverse_each.reduce([] of Array(Int32)) do |acc, i|
        if acc.empty?
            acc << ([i.first] + i)
        else
            acc << ([i.first + acc.last.first] + i)
        end
        acc
    end.reverse
end

puts "Part 2: #{histories.map{|h|extrapolate_bwd(get_deltas_bwd h).first.first}.sum}"
