require "./intcode.cr"

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)

program = Program.new(input_program)
spawn { program.run }
Fiber.yield

STDOUT << program.read_fully.map(&.chr).join
until program.is_done?
	program.write read_line
	program.write "\n"
	STDOUT << program.read_fully.map(&.chr).join
end

# p1 soln
# NOT A J
# NOT B T
# OR T J
# NOT C T
# OR T J
# AND D J
# WALK

# (!a || !b || !c) && d && (h || (e && i) || (e && f))
# (!a || !b || !c) && d && (h || (e && (i || f)))

# p2 soln
# NOT A J
# NOT B T
# OR T J
# NOT C T
# OR T J
# AND D J
# NOT I T
# NOT T T
# OR F T
# AND E T
# OR H T
# AND T J
# RUN

# d e f g h i
# 1 0 0 0 0 0 0
# 1 0 0 0 0 1 0
# 1 0 0 0 1 0 1
# 1 0 0 0 1 1 1
# 1 0 0 1 0 0 0
# 1 0 0 1 0 1 0
# 1 0 0 1 1 0 1
# 1 0 0 1 1 1 1
# 1 0 1 0 0 0 0
# 1 0 1 0 0 1 0
# 1 0 1 0 1 0 1
# 1 0 1 0 1 1 1
# 1 0 1 1 0 0 0
# 1 0 1 1 0 1 0
# 1 0 1 1 1 0 1
# 1 0 1 1 1 1 1
# 
# 1 1 0 0 0 0 0
# 1 1 0 0 0 1 1
# 1 1 0 0 1 0 1
# 1 1 0 0 1 1 1
# 1 1 0 1 0 0 0
# 1 1 0 1 0 1 1
# 1 1 0 1 1 0 1
# 1 1 0 1 1 1 1
# 1 1 1 0 0 0 ?
# 1 1 1 0 0 1 1
# 1 1 1 0 1 0 1
# 1 1 1 0 1 1 1
# 1 1 1 1 0 0 ?
# 1 1 1 1 0 1 1
# 1 1 1 1 1 0 1
# 1 1 1 1 1 1 1
