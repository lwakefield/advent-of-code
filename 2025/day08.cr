alias Vec3 = Tuple(Int64, Int64, Int64)
boxes = STDIN.gets_to_end.lines.map{|l| Vec3.from l.split(",").map(&.to_i64)}

def distance (a, b)
    x1, y1, z1 = a
    x2, y2, z2 = b
    dx, dy, dz = x2-x1, y2-y1, z2-z1

    Math.sqrt(dx**2+dy**2+dz**2)
end

dist_map = {} of Tuple(Vec3, Vec3) => Float64
boxes.each_permutation(2) do |p|
    a, b = p
    d = distance(a, b)
    next if dist_map[{b,a}]?
    dist_map[{a,b}] = d
end

circuits = [] of Set(Vec3)
boxes.each{|b| circuits << Set{b}}

dist_map_sorted_keys = dist_map.keys.sort_by {|k| dist_map[k] }
1000.times do
    a, b = dist_map_sorted_keys.shift
    ai = circuits.index!(&.includes? a)
    bi = circuits.index!(&.includes? b)

    next if ai == bi # already in the same circuit

    circuits[ai] += circuits[bi]
    circuits.delete_at bi
end
puts "part 1: #{circuits.map(&.size).sort.reverse[0...3].product}"

circuits = [] of Set(Vec3)
boxes.each{|b| circuits << Set{b}}

dist_map_sorted_keys = dist_map.keys.sort_by {|k| dist_map[k] }
la, lb = nil, nil
until circuits.size == 1
    la, lb = dist_map_sorted_keys.shift
    ai = circuits.index!(&.includes? la)
    bi = circuits.index!(&.includes? lb)

    next if ai == bi # already in the same circuit

    circuits[ai] += circuits[bi]
    circuits.delete_at bi
end
puts "part 2: #{la.not_nil![0] * lb.not_nil![0]}"