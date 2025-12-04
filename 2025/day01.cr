instrs = STDIN.gets_to_end.lines

dial = 50
passwd = 0
instrs.each do |inst|
  _, dir, amt = inst.match! /(L|R)(\d+)/
  dir = dir == "R" ? 1 : -1
  amt = amt.to_i

  dial += (dir * amt)
  until dial < 100
    dial -= 100
  end
  until dial >= 0
    dial += 100
  end

  passwd += 1 if dial == 0
end
puts "part 1: #{passwd}"

dial = 50
passwd = 0
instrs.each do |inst|
  _, dir, amt = inst.match! /(L|R)(\d+)/
  dir = dir == "R" ? 1 : -1
  amt.to_i.times do
    dial += dir
    dial = 0 if dial == 100
    dial = 99 if dial == -1
    passwd += 1 if dial == 0
  end
end
puts "part 2: #{passwd}"
