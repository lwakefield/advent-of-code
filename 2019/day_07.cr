enum ParamMode
	POS = 0
	IMM = 1
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
	END = 99
end

OP_CODE_NUM_PARAMS  = {
	Opcode::ADD    => 3,
	Opcode::MUL    => 3,
	Opcode::SAV    => 1,
	Opcode::OUT    => 1,
	Opcode::JIT    => 2,
	Opcode::JIF    => 2,
	Opcode::LT     => 3,
	Opcode::EQ     => 3,
	Opcode::END    => 0,
}

struct Operation
	getter opcode : Opcode
	getter param_mode_mask : Array(ParamMode)

	def initialize (@opcode, @param_mode_mask)
	end

	def self.from_s (in : String)
		opcode = Opcode.new( in[in.size - 2 .. ].to_i32 )
		param_mode_mask = [] of ParamMode
		(in.size - 3).downto(0) do |index|
			param_mode_mask << ParamMode.new( in[index].to_i32 )
		end

		Operation.new(opcode, param_mode_mask)
	end
end

struct Instruction
	getter operation : Operation
	getter params : Array(Int32)
	def initialize(@operation, @params)
	end

	def self.from_memory(memory : Array(Int32), instruction_pointer : Int32)
		operation = Operation.from_s(memory[instruction_pointer].to_s)
		num_params = OP_CODE_NUM_PARAMS[operation.opcode]
		params = memory[instruction_pointer + 1 ... instruction_pointer + 1 + num_params]
		Instruction.new(operation, params)
	end

	def param_mode_value (memory : Array(Int32), num : Int32)
		mode = operation.param_mode_mask[num]?
		return memory[params[num]] if mode == ParamMode::POS || mode.nil?
		return params[num] if mode == ParamMode::IMM
		raise "invalid param: #{num}"
	end

	def is? (opcode : Opcode)
		operation.opcode == opcode
	end

	def to_s(io)
		io << operation.opcode.to_s
		io << " "
		io << "(" + operation.param_mode_mask.join(",") + ")"
		io << " "
		io << params.map(&.to_s).join(" ")
	end
end

class Program
	getter memory : Array(Int32)
	getter input : Channel(Int32)
	getter output : Channel(Int32)
	@instruction_pointer = 0
	def initialize(@memory, @input = Channel(Int32).new, @output = Channel(Int32).new, @name = "")
	end

	def inst
		Instruction.from_memory(@memory, @instruction_pointer)
	end
	
	def print_memory
		@memory.each_with_index do |val, index|
			STDOUT << "#{index}: #{val} "
		end
		STDOUT << "\n"
	end

	def run
		while @instruction_pointer < @memory.size
			puts "@#{@name}[#{@instruction_pointer.to_s.rjust(4, '0')}] #{inst}"

			curr_inst = inst

			if curr_inst.is? Opcode::ADD
				@memory[curr_inst.params[2]] = curr_inst.param_mode_value(@memory, 0) + curr_inst.param_mode_value(@memory, 1)

			elsif curr_inst.is? Opcode::MUL
				@memory[curr_inst.params[2]] = curr_inst.param_mode_value(@memory, 0) * curr_inst.param_mode_value(@memory, 1)

			elsif curr_inst.is? Opcode::SAV
				arg = @input.receive
				@memory[curr_inst.params[0]] = arg

			elsif curr_inst.is? Opcode::OUT
				puts "#{@name} #{@output.closed?}"
				val = curr_inst.param_mode_value(@memory, 0)
				@output.send val
				puts "#{@name} out"

			elsif curr_inst.is? Opcode::JIT
				if curr_inst.param_mode_value(@memory, 0) != 0
					@instruction_pointer = curr_inst.param_mode_value(@memory, 1)
				else
					@instruction_pointer += 1 + curr_inst.params.size
				end

			elsif curr_inst.is? Opcode::JIF
				if curr_inst.param_mode_value(@memory, 0) == 0
					@instruction_pointer = curr_inst.param_mode_value(@memory, 1)
				else
					@instruction_pointer += 1 + curr_inst.params.size
				end

			elsif curr_inst.is? Opcode::LT
				@memory[curr_inst.params[2]] = if curr_inst.param_mode_value(@memory, 0) < curr_inst.param_mode_value(@memory, 1)
											 1
										 else
											 0
										 end

			elsif curr_inst.is? Opcode::EQ
				@memory[curr_inst.params[2]] = if curr_inst.param_mode_value(@memory, 0) == curr_inst.param_mode_value(@memory, 1)
											 1
										 else
											 0
										 end

			elsif curr_inst.is? Opcode::END
				break
			else
				raise "ERROR: unknown opcode #{curr_inst.operation.opcode} at #{@instruction_pointer}"
			end

			# print_memory
			@instruction_pointer += (1 + curr_inst.params.size) unless ( curr_inst.is?( Opcode::JIF) || curr_inst.is?(Opcode::JIT) )

		end
		return @memory
	end

	def is_done?
		inst.is? Opcode::END
	end
end

macro until_eof (arg)
	begin
		{{ arg }}
	rescue IO::EOFError
	end
end

def run_amplifier_programs (program : Array(Int32), args : Array(Int32))
	feedback_channel = Channel(Int32).new
	program_a = Program.new(program.clone, feedback_channel, name: "a")
	program_b = Program.new(program.clone, program_a.output, name: "b")
	program_c = Program.new(program.clone, program_b.output, name: "c")
	program_d = Program.new(program.clone, program_c.output, name: "d")
	program_e = Program.new(program.clone, program_d.output, feedback_channel, name: "e")


	spawn { program_a.run }
	spawn { program_b.run }
	spawn { program_c.run }
	spawn { program_d.run }
	spawn { program_e.run }

	Fiber.yield

	program_a.input.send args[0]
	program_b.input.send args[1]
	program_c.input.send args[2]
	program_d.input.send args[3]
	program_e.input.send args[4]

	program_a.input.send 0

	until program_a.is_done? || program_b.is_done? || program_c.is_done? || program_d.is_done? || program_e.is_done?
		Fiber.yield
	end

	program_e.output.receive
end

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i32)

if ARGV.includes? "--solve=1"
	max_val = [0, 1, 2, 3, 4].permutations(5).map do |args|
		run_amplifier_programs input_program.clone, args
	end.max
	puts max_val
elsif ARGV.includes? "--solve=2"
	max_val = [5, 6, 7, 8, 9].permutations(5).map do |args|
		run_amplifier_programs input_program.clone, args
	end.max
	puts max_val
elsif ARGV[1]?
	args = ARGV[1].split(",").map(&.to_i32)
	puts run_amplifier_programs input_program, args
end
