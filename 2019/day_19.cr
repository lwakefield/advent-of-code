require "./intcode.cr"
require "./vec.cr"

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)

map = {} of Vec2 => Char
(0...50).each do |x|
	(0...50).each do |y|
		program = Program.new(input_program)
		spawn { program.run }

		program.write(x.to_i64)
		program.write(y.to_i64)

		v = Vec2.new(x, y)
		val = program.read
		if val == 1
			map[v] = '#'
		else
			map[v] = '.'
		end
	end
end

# part 1
puts((0...50).map do |x|
	(0...50).map do |y|
		map[Vec2.new(x, y)]
	end.join
end.join('\n'))
puts map.values.select { |v| v == '#' }.size

# part 2
map = {} of Vec2 => Char
start_x = 0
(0...5000).each do |y|
	next_start_x = nil
	(start_x...5000).each do |x|
		program = Program.new(input_program)
		spawn { program.run }

		program.write(x.to_i64)
		program.write(y.to_i64)

		val = program.read
		next_start_x = x if val == 1 && next_start_x.nil?
		break if next_start_x && val == 0

		map[Vec2.new(x, y)] = case val
							  when 1 then '#'
							  else '.'
							  end
	end

	start_x = next_start_x unless next_start_x.nil?
end
puts "built map"

(0...5000).each do |x|
	(0...5000).each do |y|
		pos = Vec2.new(x, y)
		next if map[pos]? != '#'
		next if map[pos + (Vec2.down * 99)]? != '#'
		next if map[pos + (Vec2.right * 99)]? != '#'

		puts pos
		exit
	end
end
