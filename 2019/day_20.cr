require "./vec"

map = {} of Vec2 => Char
File.read(ARGV[0]).lines.each_with_index do |line, y|
	line.each_char_with_index do |char, x|
		map[Vec2.new(x, y)] = char
	end
end

start = map.find do |key, val|
	val == '.' && Vec2.dirs.find{ |d| map[key + d]? == 'A' }
end.not_nil![0].to_vec3

stop = map.find do |key, val|
	val == '.' && Vec2.dirs.find{ |d| map[key + d]? == 'Z' }
end.not_nil![0].to_vec3

min_x = map.select{ |k, v| v == '#' }.keys.map(&.x).min
max_x = map.select{ |k, v| v == '#' }.keys.map(&.x).max
min_y = map.select{ |k, v| v == '#' }.keys.map(&.y).min
max_y = map.select{ |k, v| v == '#' }.keys.map(&.y).max
is_outer = ->(v : Vec2) { [min_x, max_x].includes?(v.x) || [min_y, max_y].includes?(v.y) } 

portals = map.keys.reduce({} of String => Set(Vec2)) do |acc, pos|
	next acc unless map[pos] == '.'
	name = Vec2.dirs.map do |p|
		[ map[pos + p]?, map[pos + (p * 2) ]? ]
	end.flatten.compact.select(&.ascii_uppercase?).sort.join
	next acc unless name.size == 2

	acc[name] = Set(Vec2).new unless acc[name]?
	acc[name].add( pos )
	acc
end

get_portal_name = ->(pos : Vec2) {
	[
		map[pos],
		Vec2.dirs.map{ |p| map[pos + p] }.select(&.ascii_uppercase?).first,
	].sort.join
}

queue = Deque.new([ { start, 0 } ])
visited = Set.new([ start ])

until queue.empty?
	pos, d = queue.shift
	if pos == stop
		puts d
		exit 0
	end

	next unless map[pos.to_vec2]?
	next if map[pos.to_vec2] == '#'
	next if pos.z < 0

	Vec2.dirs.each do |dir|
		neighbor_pos = pos + dir.to_vec3

		next unless map[neighbor_pos.to_vec2]?

		if map[neighbor_pos.to_vec2].ascii_uppercase? # its a portal!
			portal_name = get_portal_name.call(neighbor_pos.to_vec2)
			portal_set = portals[portal_name]
			neighbor_pos = portal_set.max_by{ |p| (neighbor_pos.to_vec2 - p).l2 }.to_vec3
			neighbor_pos += Vec3.new(0, 0, pos.z)
			neighbor_pos += if portal_set.size == 1
						Vec3.zero
					elsif is_outer.call(pos.to_vec2)
						Vec3.new(0, 0, -1)
					else
						Vec3.new(0, 0, 1)
					end
		end

		if visited.includes?(neighbor_pos) == false
			visited.add neighbor_pos
			queue << { neighbor_pos, d + 1 }
		end
	end
end
