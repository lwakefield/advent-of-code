# Tue Dec  7 08:20:38 EST 2021

crab_positions = STDIN.gets.split(",").map(&:to_i)

def get_fuel_cost(positions, target)
  positions.map do |pos|
    (target - pos).abs
  end.sum
end

targets = crab_positions.sort.uniq

best = nil
best_target = nil
(targets.first..targets.last).each do |target|
  cost = get_fuel_cost(crab_positions, target)
  if best.nil? || cost < best
    best = cost
    best_target = target
  end
end

puts "part 1: #{best}"

# Tue Dec  7 08:34:08 EST 2021

fuel_cost_map = {}
(0...10000).each do |dist|
    fuel_cost_map[dist] = (fuel_cost_map[dist-1] || 0) + dist
end
def get_fuel_cost(positions, target, fuel_cost_map)
  positions.map do |pos|
    fuel_cost_map[(target - pos).abs]
  end.sum
end
best = nil
best_target = nil
(targets.first..targets.last).each do |target|
  cost = get_fuel_cost(crab_positions, target, fuel_cost_map)
  if best.nil? || cost < best
    best = cost
    best_target = target
  end
end

puts "part 2: #{best}"

# Tue Dec  7 08:40:57 EST 2021
