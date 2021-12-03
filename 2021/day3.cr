# Fri Dec  3 05:41:18 EST 2021

readings = STDIN.gets_to_end.lines

gamma, epsilon = "", ""
(0...readings.first.size).each do |i|
  one, zero = 0, 0
  readings.each do |r|
    one += 1  if r[i] == '1'
    zero += 1 if r[i] == '0'
  end

  if one > zero
    gamma += "1"
    epsilon += "0"
  else
    gamma += "0"
    epsilon += "1"
  end
end

puts "part 1, gamma=#{gamma.to_i(2)}, epsilon=#{epsilon.to_i(2)}"

# Fri Dec  3 05:51:13 EST 2021

tmp_readings = readings.clone
(0...tmp_readings.size).each do |i|
  one, zero = 0, 0
  tmp_readings.each do |r|
    one += 1  if r[i] == '1'
    zero += 1 if r[i] == '0'
  end
  if one >= zero
    tmp_readings.select!{|v| v[i] == '1' }
  else
    tmp_readings.select!{|v| v[i] == '0' }
  end

  if tmp_readings.size == 1
    puts "part 2, oxygen=#{tmp_readings.first.to_i(2)}"
    break
  end
end

tmp_readings = readings.clone
(0...tmp_readings.size).each do |i|
  one, zero = 0, 0
  tmp_readings.each do |r|
    one += 1  if r[i] == '1'
    zero += 1 if r[i] == '0'
  end
  if zero <= one
    tmp_readings.select!{|v| v[i] == '0' }
  else
    tmp_readings.select!{|v| v[i] == '1' }
  end

  if tmp_readings.size == 1
    puts "part 2, co2=#{tmp_readings.first.to_i(2)}"
    break
  end
end

# Fri Dec  3 05:59:24 EST 2021
