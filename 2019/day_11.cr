require "big"

enum ParamMode
	POS = 0
	IMM = 1
	REL = 2
end

enum Opcode
	ADD = 1
	MUL = 2
	SAV = 3
	OUT = 4
	JIT = 5
	JIF = 6
	LT  = 7
	EQ  = 8
	ARB = 9
	END = 99
end

OP_CODE_NUM_PARAMS  = {
	Opcode::ADD => 3,
	Opcode::MUL => 3,
	Opcode::SAV => 1,
	Opcode::OUT => 1,
	Opcode::JIT => 2,
	Opcode::JIF => 2,
	Opcode::LT  => 3,
	Opcode::EQ  => 3,
	Opcode::ARB => 1,
	Opcode::END => 0,
}

class Program
	getter memory : Array(BigInt)
	getter input : Channel(BigInt)
	getter output : Channel(BigInt)
	@instruction_pointer : BigInt = 0.to_big_i
	@relative_base_offset : BigInt = 0.to_big_i

	def initialize(@memory, @input = Channel(BigInt).new, @output = Channel(BigInt).new)
	end

	def opcode
		Opcode.new( (memory[@instruction_pointer] % 100).to_i )
	end

	def param_mode (num : Int32)
		ParamMode.new ( memory[@instruction_pointer] / (10 ** (num + 2)) % 10 ).to_i
	end

	def param_val (num : Int32): BigInt
		mode = param_mode(num)

		return get_memory(@instruction_pointer + num + 1) if mode == ParamMode::IMM

		return get_memory addr(num)
	end

	def addr (num : Int32)
		mode = param_mode(num)

		case mode
		when  ParamMode::POS, nil
			return @memory[@instruction_pointer + num + 1]
		when ParamMode::REL
			return @relative_base_offset + @memory[@instruction_pointer + num + 1]
		end

		raise "invalid addr: #{num}"
	end
	
	def run
		while @instruction_pointer < @memory.size
			case opcode
			when Opcode::ADD
				set_memory addr(2), self.param_val(0) + self.param_val(1)
			when Opcode::MUL
				set_memory addr(2), self.param_val(0) * self.param_val(1)
			when Opcode::SAV
				set_memory addr(0), @input.receive
			when Opcode::OUT
				@output.send self.param_val(0)
			when Opcode::JIT
				if self.param_val(0) != 0
					@instruction_pointer = self.param_val(1)
					next
				end
			when Opcode::JIF
				if self.param_val(0) == 0
					@instruction_pointer = self.param_val(1)
					next
				end
			when Opcode::LT
				set_memory addr(2), (self.param_val(0) < self.param_val(1) ? 1 : 0)
			when Opcode::EQ
				set_memory addr(2), (self.param_val(0) == self.param_val(1) ? 1 : 0)
			when Opcode::ARB
				@relative_base_offset += self.param_val(0)
			when Opcode::END
				output.close
				break
			else
				raise "ERROR: unknown opcode #{opcode} at #{@instruction_pointer}"
			end

			@instruction_pointer += (1 + OP_CODE_NUM_PARAMS[opcode])
		end

		return @memory
	end

	def set_memory (address : BigInt, val)
		until address < @memory.size
			@memory = @memory + ([0.to_big_i] * @memory.size)
		end

		@memory[address] = val.to_big_i
	end

	def get_memory (address : BigInt): BigInt
		@memory[address]? || 0.to_big_i
	end

	def is_done?
		opcode == Opcode::END
	end
end

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_big_i)

program = Program.new(input_program)
spawn { program.run }

alias Point = Tuple(Int32, Int32)
plates = {} of Point => Int32
BLACK = 0
WHITE = 1
DIR_UP    = {0, 1}
DIR_RIGHT = {1, 0}
DIR_DOWN  = {0, -1}
DIR_LEFT  = {-1, 0}
DIRECTIONS = [
	DIR_UP,
	DIR_RIGHT,
	DIR_DOWN,
	DIR_LEFT
]

curr_pos = {0, 0}
curr_dir_index = 0

plates[curr_pos] = WHITE

until program.is_done?
	program.input.send( plates.fetch(curr_pos, BLACK).to_big_i )

	to_paint = program.output.receive
	plates[curr_pos] = to_paint.to_i

	turn_dir = program.output.receive
	curr_dir_index += turn_dir.to_i == 0 ? -1 : 1
	curr_dir_index %= DIRECTIONS.size

	delta = DIRECTIONS[curr_dir_index]
	curr_pos = { curr_pos[0] + delta[0], curr_pos[1] + delta[1] }

	Fiber.yield
end

min_x = plates.keys.map(&.[0]).min
max_x = plates.keys.map(&.[0]).max
min_y = plates.keys.map(&.[1]).min
max_y = plates.keys.map(&.[1]).max

output = Array(Array(Int32)).new
max_y.downto(min_y).each do |y|
	row = [] of Int32
	min_x.upto(max_x).each do |x|
		row << plates.fetch({x, y}, BLACK)
	end
	output << row
end
STDOUT << output.map do |row|
	row.map do |val|
		if val == BLACK
			"█"
		elsif val == WHITE
			" "
		else
			"?"
		end
	end.join("")
end.join("\n")
