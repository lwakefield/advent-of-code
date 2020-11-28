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
	getter memory : Array(Int64)
	getter input : Channel(Int64)
	getter output : Channel(Int64)
	@instruction_pointer : Int64 = 0.to_i64
	@relative_base_offset : Int64 = 0.to_i64

	def initialize(@memory, @input = Channel(Int64).new, @output = Channel(Int64).new)
	end

	def opcode (at = @instruction_pointer)
		Opcode.from_value( (memory[at] % 100 ).to_i )
	end

	def param_mode (num : Int32, at = @instruction_pointer)
		ParamMode.from_value( memory[at] / (10 ** (num + 2)) % 10 )
	end

	def param_val (num : Int32, from = @instruction_pointer): Int64
		mode = param_mode(num, from)

		return get_memory(from + num + 1) if mode == ParamMode::IMM

		return get_memory addr(num)
	end

	def dump_memory
		offset = 0i64
		until offset > @memory.size
			begin
				opcode = opcode(offset)
				num_params = OP_CODE_NUM_PARAMS[opcode]

				modes = (0...num_params).map{ |i| param_mode(i, offset) }
				params = (1..num_params).map{ |i| get_memory(offset + i) }

				puts "#{
					offset.to_s.rjust(8, '0')
				} #{
					opcode
				} #{
					modes.zip(params).map{|mode, param| "#{mode}:#{param}"}.join(", ")
				}"

				offset += 1 + num_params

			rescue
				puts "#{ offset.to_s.rjust(8, '0') } #{ get_memory(offset) }"
				offset += 1
			end
		end
	end

	def addr (num : Int32, from = @instruction_pointer)
		mode = param_mode(num, from)

		case mode
		when  ParamMode::POS, nil
			return @memory[from + num + 1]
		when ParamMode::REL
			return @relative_base_offset + @memory[from + num + 1]
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

	def set_memory (address : Int64, val)
		until address < @memory.size
			@memory = @memory + ([0.to_i64] * @memory.size)
		end

		@memory[address] = val.to_i64
	end

	def get_memory (address : Int64): Int64
		@memory[address]? || 0.to_i64
	end

	def is_done?
		opcode == Opcode::END
	end
end

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)


alias Point = Tuple(Int64, Int64)

if ARGV.includes? "--solve=1"
	program = Program.new(input_program)
	spawn { program.run }

	screen = Hash(Point, Int64).new
	until program.is_done?
		x = program.output.receive
		y = program.output.receive
		val = program.output.receive
		screen[{x, y}] = val
		Fiber.yield
	end
	puts screen.values.select{|val| val == 2}.size
end

if ARGV.includes? "--dump"
	Program.new(input_program).dump_memory
	exit
end

if ARGV.includes? "--solve=2"
	program = Program.new(input_program)
	program.memory[0] = 2
	spawn { program.run }

	screen = Hash(Point, Int64).new

	finished_channel = Channel(Int32).new

	STDOUT << "\e[2J"
	STDOUT << "\e[?25l"

	paddle_x = 0
	ball_x = 0
	spawn do
		until program.is_done?
			x = program.output.receive
			y = program.output.receive
			val = program.output.receive

			if x == -1 && y == 0
				STDOUT.raw(&.puts("\e[1;1Hscore: #{val}"))
				next
			end

			char = case val
				when 1 then '|'
				when 2 then '#'
				when 3 then '-'
				when 4 then 'x'
				else ' '
			end

			if char == 'x'
				ball_x = x
			elsif char == '-'
				paddle_x = x
			end

			STDOUT.raw(&.puts("\e[#{y+1};#{x+1}H#{char}"))

			Fiber.yield
		end
		finished_channel.send(1)
	end

	spawn do
		until program.is_done?
			char = STDIN.raw(&.read_char)
			if char == 3.chr
				exit 1
			end

			dir = (ball_x - paddle_x).sign

			program.input.send dir.to_i64
			Fiber.yield
		end
		finished_channel.send(1)
	end

	at_exit do
		STDOUT << "\e[2J"
		STDOUT << "\e[?25h"
	end

	finished_channel.receive
	finished_channel.receive
end
