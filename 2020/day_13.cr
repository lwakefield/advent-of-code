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

def find_period(start_t, step, y, delta)
  t = start_t
  until (t + delta) % y == 0
    t += step
  end
  period_start = t
  t += step
  until (t + delta) % y == 0
    t += step
  end
  { period_start, t }
end

def crack_code_2 (parts)
  numbers = parts.compact

  period = {0u64, numbers.first}
  (1...numbers.size).each do |idx|
    delta = parts.index(numbers[idx]).not_nil! - parts.index(numbers[0]).not_nil!
    period = find_period(period[0], period[1] - period[0], numbers[idx], delta)
    puts period
   end

end

crack_code_2(
  lines[1].split(",").map { |b| b == "x" ? nil : b.to_u64 }
)
