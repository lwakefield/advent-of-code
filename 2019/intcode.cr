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

enum Signals
	DONE
	AWAITING_INPUT
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
	getter input, output
	@instruction_pointer : Int64 = 0.to_i64
	@relative_base_offset : Int64 = 0.to_i64

	def initialize(
		@memory,
		@input = Deque(Int64).new,
		@output = Deque(Int64).new
	)
	end

	def opcode (at = @instruction_pointer)
		Opcode.from_value( (memory[at] % 100 ).to_i )
	end

	def param_mode (num : Int32, at = @instruction_pointer)
		ParamMode.from_value( (memory[at] / (10 ** (num + 2)) % 10).to_i )
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
				if input.empty?
					return Signals::AWAITING_INPUT
				else
					set_memory addr(0), input.shift
				end
			when Opcode::OUT
				output << self.param_val(0)
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
				break
			else
				raise "ERROR: unknown opcode #{opcode} at #{@instruction_pointer}"
			end

			@instruction_pointer += (1 + OP_CODE_NUM_PARAMS[opcode])
		end

		return Signals::DONE
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

	def write (vals : Enumerable)
		input.concat(vals.map(&.to_i64))
		# Fiber.yield
	end

	def write (val : String)
		write val.chars.map(&.ord)
	end

	def write (val)
		input << val.to_i64
		# Fiber.yield
	end

	def read?
		return nil if output.empty?

		read
	end

	def read
		val = output.shift
		# Fiber.yield
		val
	end

	def read_fully
		res = output.to_a
		output.shift(output.size)
		# Fiber.yield
		res
	end
end
