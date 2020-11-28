require "./intcode"
require "./vec"

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)

program = Program.new(input_program)
program.run

str = program.read_fully.map(&.chr).join

rows = str.lines.select { |s| s.strip != "" }
intersections = [] of Vec2
rows.each_with_index do |row, y|
	row.chars.each_with_index do |val, x|
		next unless val == '#'
		next if y == 0 || y == (rows.size - 1)
		next if x == 0 || x == (row.size - 1)
		next unless rows[y - 1][x] == '#'
		next unless rows[y + 1][x] == '#'
		next unless rows[y][x - 1] == '#'
		next unless rows[y][x + 1] == '#'
		intersections <<  Vec2.new(x, y)
	end
end
puts str
puts intersections.sum { |vec| vec.x * vec.y }

# PART 2


def find_pos_dir (rows : Array(String))
	start_pos = nil
	start_dir = nil
	rows.each_with_index do |row, y|
		row.each_char_with_index do |val, x|
			return { Vec2.new(x, y), Vec2.up } if val == '^'
			return { Vec2.new(x, y), Vec2.down } if val == 'v'
			return { Vec2.new(x, y), Vec2.left } if val == '<'
			return { Vec2.new(x, y), Vec2.right } if val == '>'
		end
	end
	raise "not found"
end

def find_next_dirs (rows : Array(String), pos : Vec2, dir : Vec2)
	options = [] of Vec2

	x, y = pos.x, pos.y
	options << Vec2.up if rows[y - 1]? && rows[y - 1][x]? == '#'
	options << Vec2.down if rows[y + 1]? && rows[y + 1][x]? == '#'
	options << Vec2.left if rows[y][x - 1]? == '#'
	options << Vec2.right if rows[y][x + 1]? == '#'

	options
end

def get_turn (vec_a : Vec2, vec_b : Vec2)
	if vec_a == vec_b
		return [] of String
	end
	case { vec_a, vec_b }
	when { Vec2.up,    Vec2.right } then ["R"]
	when { Vec2.up,    Vec2.down  } then ["R"] * 2
	when { Vec2.up,    Vec2.left  } then ["L"]
	when { Vec2.right, Vec2.down  } then ["R"]
	when { Vec2.right, Vec2.left  } then ["R"] * 2
	when { Vec2.right, Vec2.up    } then ["L"]
	when { Vec2.down,  Vec2.left  } then ["R"]
	when { Vec2.down,  Vec2.up    } then ["R"] * 2
	when { Vec2.down,  Vec2.right } then ["L"]
	when { Vec2.left,  Vec2.up    } then ["R"]
	when { Vec2.left,  Vec2.right } then ["R"] * 2
	when { Vec2.left,  Vec2.down  } then ["L"]
	else
		raise "could not get_turn"
	end
end

def get_dist_to_end (rows : Array(String), pos : Vec2, dir : Vec2)
	next_pos = pos + dir
	dist = 0

	while (0...rows.size).includes?( next_pos.y ) && (0...rows.first.size).includes?( next_pos.x ) && rows[next_pos.y][next_pos.x]? == '#'
		dist += 1
		next_pos += dir
	end

	dist
end


pos, dir = find_pos_dir(rows)
path = [] of String

loop do
	next_dirs = find_next_dirs(rows, pos, dir).reject { |v| v == Vec2.new(-dir.x, -dir.y) }
	break if next_dirs.empty?
	next_dir = next_dirs.first
	dist = get_dist_to_end(rows, pos, next_dir)

	path += get_turn(dir, next_dir)
	path << dist.to_s

	dir = next_dir
	pos += dir * dist
end

puts path.join(",")
puts path.size

# Factorized by hand
# A: R,6,L,10,R,8
# B: R,8,R,12,L,8,L,8
# C: L,10,R,6,R,6,L,8
# A,B,A,B,C,A,B,C,A,C

program = Program.new(input_program)
program.memory[0] = 2.to_i64
spawn { program.run }

input = "
A,B,A,B,C,A,B,C,A,C
R,6,L,10,R,8
R,8,R,12,L,8,L,8
L,10,R,6,R,6,L,8
".strip

Fiber.yield

input.lines.each do |line|
	STDOUT << program.read_fully.map(&.chr).join
	program.write "#{line}\n"
end
STDOUT << program.read_fully.map(&.chr).join
program.write "n\n"

until program.output.empty?
	out = program.read
	begin
		STDOUT << out.chr
	rescue
		STDOUT << out.to_s
	end
end
