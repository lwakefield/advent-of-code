require "log"

# Mon Dec  6 06:00:02 EST 2021

fishies = STDIN.gets_to_end.split(",").map(&.to_i32)

def tick(fishies)
  new_fishes = [] of Int32
  fishies.each do |fish|
    if fish == 0
      new_fishes << 6
      new_fishes << 8
    else
      new_fishes << fish - 1
    end
  end
  new_fishes
end

def tick(fishies, n)
  n.times do |n|
    # Log.info { "Tick #{n}" }
    fishies = tick(fishies)
  end
  fishies
end

# puts "part 1: #{tick(fishies, 80).size}"

# Mon Dec  6 06:05:19 EST 2021

fishies_map = {} of Int32 => Int32
fishies.each do |f|
  fishies_map[f] ||= 0
  fishies_map[f] += 1
end

def tick2 (fishies_map, n)
  n.times do
    next_fishies_map = {} of Int32 => Int64
    fishies_map.each do |k, v|
      if k == 0
        next_fishies_map[8] ||= 0
        next_fishies_map[8] += v
        next_fishies_map[6] ||= 0
        next_fishies_map[6] += v
      else
        next_fishies_map[k-1] ||= 0
        next_fishies_map[k-1] += v
      end
    end
    fishies_map = next_fishies_map
  end
  fishies_map
end

puts "part1: #{tick2(fishies_map, 80).values.sum}"
puts "part2: #{tick2(fishies_map, 256).values.sum}"

# Mon Dec  6 06:20:36 EST 2021
