
# start Thu Dec  2 05:56:20 EST 2021
# part 1 Thu Dec  2 06:00:00 EST 2021
# part 3 Thu Dec  2 06:02:41 EST 2021

# x, y = 0, 0
# STDIN.each_line do |line|
#   dir, amt = line.split

#   case dir
#   when "forward" then x += amt.to_i32
#   when "up"      then y -= amt.to_i32
#   when "down"    then y += amt.to_i32
#   end
# end

# puts "Part 1: #{x * y}"

x, y, aim = 0, 0, 0
STDIN.each_line do |line|
  dir, amt = line.split

  case dir
  when "forward" 
    x += amt.to_i32
    y += aim * amt.to_i32
  when "up"      then aim -= amt.to_i32
  when "down"    then aim += amt.to_i32
  end
end

puts "Part 2: #{x * y}"
