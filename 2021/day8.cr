# Wed Dec  8 06:15:50 EST 2021
require "set"

input = ARGF.read.lines.map do |line|
  line.split(" | ").map{|v| v.split(" ").map{|v| v.chars.to_set}}
end

puts "part 1: #{input.map{|v|v[1]}.flatten.select do |v|
  v.size == 2 ||
    v.size == 4 ||
    v.size == 3 ||
    v.size == 7
end.size}"

# Wed Dec  8 06:25:44 EST 2021

# 0: 6 parts
# 1: 2 parts
# 2: 5 parts
# 3: 5 parts
# 4: 4 parts
# 5: 5 parts
# 6: 6 parts
# 7: 3 parts
# 8: 7 parts
# 9: 6 parts

# 5: 2, 3, 5, 9
# 6: 0, 6, 9

def decode (left, right)
  all = left + right
  one = all.find { |v| v.size == 2 }
  four = all.find { |v| v.size == 4 }
  seven = all.find { |v| v.size == 3 }
  eight = all.find { |v| v.size == 7 }

  three = all.find{|v| v.size == 5 && one.subset?(v)}

  two_five = all.select{|v| v.size == 5 && (v&one).size==1}

  six = all.find{|v| v.size == 6 && (v&one).size==1}
  five = two_five.find{|v| (six-v).size==1}
  two = two_five.find{|v| v!=five}
  nine = all.find{|v| v.size == 6 && (v&four).size==4}
  zero = all.find{|v| v.size == 6 && v!=nine && v!=six}

  {
    zero => 0,
    one => 1,
    two => 2,
    three => 3,
    four => 4,
    five => 5,
    six => 6,
    seven => 7,
    eight => 8,
    nine => 9,
  }
end


puts "part 2: #{input.map do |eqn|
  left, right = eqn
  decode_map = decode(left, right)
  right.map {|v| decode_map[v]}.join.to_i
end.sum}"


# Wed Dec  8 06:56:00 EST 2021
