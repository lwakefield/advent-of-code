require "./intcode"
require "./vec"

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)

program = Program.new(input_program)
spawn { program.run }
Fiber.yield

map = {} of Vec2 => Int64
visited = Set.new [Vec2.zero]
to_visit = [] of Vec2
path = [Vec2.zero] of Vec2

loop do
	neighbors = check_neighbors(program)

	neighbors.each do |neighbor_dir, status|
		map[path.last + neighbor_dir] = status
		pos = path.last + neighbor_dir

		if status != 0 && !visited.includes?(pos)
			to_visit << pos
		end
	end
	break if to_visit.empty?

	next_pos = to_visit.find do |other_pos|
		(path.last - other_pos).l2 == 1.0
	end

	if next_pos.nil?
		# backtrack!
		signal = vec2_to_signal(path[-2] - path[-1])
		path.pop
		program.write(signal.to_i64)
		program.read
	else
		signal = vec2_to_signal(next_pos - path.last)
		program.write(signal.to_i64)
		program.read

		to_visit.delete(next_pos)
		path << next_pos
		visited.add(next_pos)
	end

	# STDOUT << "\e[2J"
	# puts "----------------"
	# print_map(map, path.last)
	# read_line
end

oxygen = map.find do |key, val|
	val == 2
end
exit 1 unless oxygen

map[oxygen[0]] = 3

minutes = 0
until map.values.all? { |v| v == 3 || v == 0 }
	next_map = map.clone
	map.each do |key, val|
		next unless val == 3

		next_map[key + Vec2.up]    = 3 unless map[key + Vec2.up]? == 0
		next_map[key + Vec2.down]  = 3 unless map[key + Vec2.down]? == 0
		next_map[key + Vec2.left]  = 3 unless map[key + Vec2.left]? == 0
		next_map[key + Vec2.right] = 3 unless map[key + Vec2.right]? == 0
	end
	map = next_map
	minutes += 1

	# STDOUT << "\e[2J"
	# puts "----------------"
	# print_map(map, path.last)
	# read_line
end
puts minutes
exit 0

def vec2_to_signal (vec : Vec2)
	case vec
	when Vec2.new(-1, 0) then 3
	when Vec2.new(0, 1) then 2
	when Vec2.new(0, -1) then 1
	when Vec2.new(1, 0) then 4
	else raise "invalid #{vec}"
	end
end

def print_map (map : Hash(Vec2, Int64), curr : Vec2)
	min_x = map.keys.map(&.x).min
	max_x = map.keys.map(&.x).max
	min_y = map.keys.map(&.y).min
	max_y = map.keys.map(&.y).max

	min_y.upto(max_y).each do |y|
		line = ""
		min_x.upto(max_x).each do |x|
			if Vec2.new(x, y) == curr
				line += 'D'
				next
			end

			line += case map[Vec2.new(x, y)]?
			when 0 then '#'
			when 1 then '.'
			when 2 then '!'
			when 3 then 'O'
			else ' '
			end
		end
		puts line
	end
end

def check_neighbors (program)
	neighbors = {} of Vec2 => Int64

	program.write(1)
	status = program.read
	neighbors[Vec2.new(0, -1)] = status
	if status != 0
		program.write(2)
		program.read
	end

	program.write(2)
	status = program.read
	neighbors[Vec2.new(0, 1)] = status
	if status != 0
		program.write(1)
		program.read
	end

	program.write(3)
	status = program.read
	neighbors[Vec2.new(-1, 0)] = status
	if status != 0
		program.write(4)
		program.read
	end

	program.write(4)
	status = program.read
	neighbors[Vec2.new(1, 0)] = status
	if status != 0
		program.write(3)
		program.read
	end

	neighbors
end
