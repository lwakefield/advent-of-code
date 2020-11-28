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
	Opcode::END    => 3,
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
end

def run (memory : Array(Int32))
	instruction_pointer = 0
	while instruction_pointer < memory.size
		inst = Instruction.from_memory(memory, instruction_pointer)

		if inst.is? Opcode::ADD
			memory[inst.params[2]] = inst.param_mode_value(memory, 0) + inst.param_mode_value(memory, 1)

		elsif inst.is? Opcode::MUL
			memory[inst.params[2]] = inst.param_mode_value(memory, 0) * inst.param_mode_value(memory, 1)

		elsif inst.is? Opcode::SAV
			STDOUT << "Input: "
			input = read_line.strip.to_i32
			memory[inst.params[0]] = input

		elsif inst.is? Opcode::OUT
			STDOUT << "Output: #{inst.param_mode_value(memory, 0)}\n"

		elsif inst.is? Opcode::JIT
			if inst.param_mode_value(memory, 0) != 0
				instruction_pointer = inst.param_mode_value(memory, 1)
			else
				instruction_pointer += 1 + inst.params.size
			end

		elsif inst.is? Opcode::JIF
			if inst.param_mode_value(memory, 0) == 0
				instruction_pointer = inst.param_mode_value(memory, 1)
			else
				instruction_pointer += 1 + inst.params.size
			end

		elsif inst.is? Opcode::LT
			memory[inst.params[2]] = if inst.param_mode_value(memory, 0) < inst.param_mode_value(memory, 1)
										 1
									 else
										 0
									 end

		elsif inst.is? Opcode::EQ
			memory[inst.params[2]] = if inst.param_mode_value(memory, 0) == inst.param_mode_value(memory, 1)
										 1
									 else
										 0
									 end

		elsif inst.is? Opcode::END
			break
		else
			raise "ERROR: unknown opcode #{inst.operation.opcode} at #{instruction_pointer}"
		end

		instruction_pointer += (1 + inst.params.size) unless ( inst.is?( Opcode::JIF) || inst.is?(Opcode::JIT) )

	end
	return memory
end

memory = File.read(ARGV[0]).split(',').map(&.strip).map(&.to_i32)
puts run(memory)
