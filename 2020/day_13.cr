lines = File.read_lines(ARGV.first? || "./day_13.txt")
timestamp = lines[0].to_i

next_bus_id = nil
next_bus_at = Int32::MAX
lines[1].split(",").each do |id|
  next if id == "x"

  id = id.to_i

  next_at = timestamp + (id - timestamp % id)
  if next_at < next_bus_at
    next_bus_id = id
    next_bus_at = next_at
  end
end

puts "part 1: #{next_bus_id.not_nil! * (next_bus_at - timestamp)}"

buses = lines[1].split(",").reject("x").map(&.to_i)
first_bus, last_bus = buses.first, buses.last

n = 1
loop do
  first_bus_t = n * first_bus
  if first_bus_t % last_bus == 0
    puts "found period at #{first_bus_t}"
    exit
  end

  n += 1
end
