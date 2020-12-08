alias Instruction = Tuple(String, Int32)

instructions = [] of Instruction
File.each_line(ARGV.first? || "./day_08.txt") do |line|
  opcode, arg = line.split(" ")
  instructions << {opcode, arg.to_i}
end

inst_ptr = 0
acc = 0
visited = Set(Int32).new

# part 1
# loop do
#   if visited.includes? inst_ptr
#     puts acc
#     exit 0
#   end
# 
#   visited.add(inst_ptr)
#   opcode, arg = instructions[inst_ptr]
#   case opcode
#   when "acc"
#     acc += arg
#     inst_ptr += 1
#   when "jmp"
#     inst_ptr += arg
#   when "nop"
#     inst_ptr += 1
#   end
# end

def run_prog(instructions, max_ticks = 1_000_000)
  inst_ptr = 0
  acc = 0
  tick = 0

  while inst_ptr < instructions.size && tick < max_ticks
    opcode, arg = instructions[inst_ptr]
    case opcode
    when "acc"
      acc += arg
      inst_ptr += 1
    when "jmp"
      inst_ptr += arg
    when "nop"
      inst_ptr += 1
    end

    tick += 1
  end

  raise "timed out" unless tick < max_ticks

  acc
end

instructions.each_with_index do |inst, index|
    next unless ["nop", "jmp"].includes? inst[0]

    test_program = instructions.clone
    test_program[index] = { "nop", inst[1] } if inst[0] == "jmp"
    test_program[index] = { "jmp", inst[1] } if inst[0] == "nop"

    begin
        puts "testing swapping inst at #{index}"
        acc = run_prog test_program
        puts "fixed the program by swapping inst at #{index}"
        puts "acc=#{acc}"
    rescue e
    end
end
