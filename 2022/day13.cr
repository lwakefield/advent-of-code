pairs_of_packets = STDIN.gets_to_end.split("\n\n").map(&.lines.map(&.scan(/\d+|,|[\[\]]/).map(&.[0])))

alias NestedArray = Int32 | Array(Int32) | Array(NestedArray)

def convert (a) : NestedArray
  raise "exepected array" unless a.responds_to? :first?
  raise "expected [" unless a.first? == "["
  a.shift

  r = [] of NestedArray
  until a.first? == "]"
    case a.first
    when "["
      r << convert a
    when ","
      a.shift
    else
      r << a.shift.to_i
    end
  end

  raise "expected ]" unless a.first == "]"
  a.shift

  r
end

macro is_array?(a)
  {{a}}.is_a?(Array(Int32)|Array(NestedArray))
end

def compare(l, r)
  if l.is_a?(Int32) && r.is_a?(Int32)
    return (l-r).sign
  elsif is_array?(l) && is_array?(r)
    until l.empty? || r.empty?
      o = compare(l.shift, r.shift)
      return o unless o==0
    end
    return (l.size - r.size).sign
  elsif l.is_a?(Int32) && is_array?(r)
    return compare([l].as(NestedArray), r)
  elsif is_array?(l) && r.is_a?(Int32)
    return compare(l, [r].as(NestedArray))
  end
  return 0
end

part1 = 0
pairs_of_packets.each_with_index do |pair,i|
  l, r = pair
  l, r = convert(l.dup), convert(r.dup)
  o = compare(l,r)
  part1 += i+1 if o == -1
end
puts "part 1: #{part1}"

divider_packets = [
  ["[", "[", "2", "]", "]"],
  ["[", "[", "6", "]", "]"]
]
flat_packets = pairs_of_packets.reduce([] of Array(String)){|a,v| a+=v}
flat_packets += divider_packets
flat_packets.sort! do |a, b|
  compare(convert(a.dup), convert(b.dup))
end
puts "part 2: #{(flat_packets.index(divider_packets[0]).not_nil!+1)*(flat_packets.index(divider_packets[1]).not_nil!+1)}"
