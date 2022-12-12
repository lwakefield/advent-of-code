# test data
# monkeys = [
#   [79, 98],
#   [54, 65, 75, 74],
#   [79, 60, 97],
#   [74],
# ]
# inspection_counts = [0]*monkeys.size
# ops = [
#   ->(x : UInt64){x * 19},
#   ->(x : UInt64){x + 6},
#   ->(x : UInt64){x * x},
#   ->(x : UInt64){x + 3},
# ]
# throw = [
#   ->(x : UInt64){x%23==0?2:3},
#   ->(x : UInt64){x%19==0?2:0},
#   ->(x : UInt64){x%13==0?1:3},
#   ->(x : UInt64){x%17==0?0:1},
# ]

monkeys = [
  [91u64, 58u64, 52u64, 69u64, 95u64, 54u64],
  [80u64, 80u64, 97u64, 84u64],
  [86u64, 92u64, 71u64],
  [96u64, 90u64, 99u64, 76u64, 79u64, 85u64, 98u64, 61u64],
  [60u64, 83u64, 68u64, 64u64, 73u64],
  [96u64, 52u64, 52u64, 94u64, 76u64, 51u64, 57u64],
  [75u64],
  [83u64, 75u64],
]
inspection_counts = [0u64]*monkeys.size

ops = [
  ->(x : UInt64){x * 13},
  ->(x : UInt64){x * x},
  ->(x : UInt64){x + 7},
  ->(x : UInt64){x + 4},
  ->(x : UInt64){x * 19},
  ->(x : UInt64){x + 3},
  ->(x : UInt64){x + 5},
  ->(x : UInt64){x + 1},
]
throw = [
  ->(x : UInt64){x%7 ==0?1:5},
  ->(x : UInt64){x%3 ==0?3:5},
  ->(x : UInt64){x%2 ==0?0:4},
  ->(x : UInt64){x%11==0?7:6},
  ->(x : UInt64){x%17==0?1:0},
  ->(x : UInt64){x%5 ==0?7:3},
  ->(x : UInt64){x%13==0?4:2},
  ->(x : UInt64){x%19==0?2:6},
]

# part 1
# 20.times do
#   monkeys.each_with_index do |m,mi|
#     m.map!{|i|ops[mi].call(i)}.map!{|i|i//3}
#     inspection_counts[mi] += m.size
#     while i=m.shift?
#       monkeys[throw[mi].call(i)] << i
#     end
#   end
# end
# puts "part 1: #{inspection_counts.sort[-2..-1].product}"

div = 2.lcm(3).lcm(5).lcm(7).lcm(11).lcm(13).lcm(15).lcm(17).lcm(19).to_u64
10_000.times do
  monkeys.each_with_index do |m,mi|
    m.map!{|i|ops[mi].call(i)}.map!{|i|i%div}
    inspection_counts[mi] += m.size
    while i=m.shift?
      monkeys[throw[mi].call(i)] << i
    end
  end
end
puts "part 2: #{inspection_counts.sort[-2..-1].product}"
