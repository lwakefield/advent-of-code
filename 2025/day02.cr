ranges = STDIN.gets_to_end.split(",").map do |r|
  start, stop = r.split "-"
  (start.to_i64..stop.to_i64)
end

def is_repeating_p1?(str)
  str[0...str.size//2] * 2 == str
end

def is_repeating_p2?(str)
  (1..str.size//2).each do |i|
    return true if (str[0...i] * (str.size // i)) == str
  end
end

# pp is_repeating?("12345")
# pp is_repeating?("1010")
# pp is_repeating?("55")
# pp is_repeating?("11")

sum = 0i64
ranges.each do |r|
  r.each do |id|
    sum += id if is_repeating_p1?(id.to_s)
  end
end
puts "part 1: #{sum}"

sum = 0i64
ranges.each do |r|
  r.each do |id|
    sum += id if is_repeating_p2?(id.to_s)
  end
end
puts "part 1: #{sum}"
