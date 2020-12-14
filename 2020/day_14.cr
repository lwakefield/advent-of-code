def apply_mask(val, mask)
  res = ""
  val.to_s(2).rjust(mask.size, '0').chars.zip(mask.chars) do |v, m|
    res += m == 'X' ? v : m
  end
  res.to_u64(2)
end

def apply_mask_2(val, mask)
  res = ""
  val.to_s(2).rjust(mask.size, '0').chars.zip(mask.chars) do |v, m|
    res += v if m == '0'
    res += '1' if m == '1'
    res += 'X' if m == 'X'
  end
  decode_addr(res).map{ |v| v.to_u64(2) }
end

def decode_addr(addr) : Array(String)
  if addr.size == 1
    return addr == "X" ? ["0", "1"] : [addr]
  elsif addr[0]? == '1' || addr[0]? == '0'
    return decode_addr(addr[1..]).map do |a|
      addr[0] + a
    end
  elsif addr[0]? == 'X'
    return decode_addr(addr[1..]).reduce([] of String) do |acc, curr|
      acc << '0' + curr
      acc << '1' + curr
    end
  else
    return [] of String
  end
end

# part 1
mask = "X" * 36
mem = {} of UInt64 => UInt64
File.each_line("day_14.txt") do |line|
  if m = line.match(/(?<=mask = ).+/)
    mask = m[0]
  elsif m = line.match(/mem\[(?<addr>\d+)\] = (?<val>\d+)/)
    mem[m["addr"].to_u64] = apply_mask(m["val"].to_u64, mask)
  end
end

puts mem.values.sum

# part 2
mask = "X" * 36
mem = {} of UInt64 => UInt64
File.each_line("day_14.txt") do |line|
  if m = line.match(/(?<=mask = ).+/)
    mask = m[0]
  elsif m = line.match(/mem\[(?<addr>\d+)\] = (?<val>\d+)/)
    apply_mask_2(m["addr"].to_u64, mask).each do |addr|
      mem[addr] = m["val"].to_u64
    end
  end
end

puts mem.values.sum
