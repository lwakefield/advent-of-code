OPCODE_ADD = 1
OPCODE_MUL = 2
OPCODE_END = 99

InstructionPointer = 0
Memory = STDIN.gets_to_end.split(',').map(&.strip).map(&.to_i32)

def run (memory)
	instruction_pointer = 0
	while instruction_pointer < memory.size
		opcode = memory[instruction_pointer]

		if opcode == OPCODE_ADD
			param_one        = memory[instruction_pointer + 1]
			param_two       = memory[instruction_pointer + 2]
			param_three = memory[instruction_pointer + 3]
			memory[param_three] = memory[param_one] + memory[param_two]
		elsif opcode == OPCODE_MUL
			param_one        = memory[instruction_pointer + 1]
			param_two       = memory[instruction_pointer + 2]
			param_three = memory[instruction_pointer + 3]
			memory[param_three] = memory[param_one] * memory[param_two]
		elsif opcode == OPCODE_END
			break
		else
			raise "ERROR: unknown opcode #{opcode} at #{instruction_pointer}\n"
		end

		instruction_pointer += 4
	end
	return memory
end

memory = STDIN.gets_to_end.split(',').map(&.strip).map(&.to_i32)
if ARGV.includes? "--fix"
	memory[1] = 12
	memory[2] = 2
	puts run(memory).join(",")
elsif ARGV.includes? "--solve"
	answer = 19690720
	(0..99).each do |noun|
		(0..99).each do |verb|
			new_memory = memory.clone
			new_memory[1] = noun
			new_memory[2] = verb

			result = run(new_memory)
			if result[0] == answer
				STDOUT << "Solved with noun: #{noun} verb: #{verb}\n"
				exit 0
			end
		end
	end
	STDERR << "Could not solve\n"
	exit 1
else
	puts run(memory).join(",")
end
