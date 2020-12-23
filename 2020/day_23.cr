require "time"
cups = Deque.new (ARGV.first? || "523764819").chars.map(&.to_i)


def solve(cups : Deque(Int32), iterations)
  start = Time.local
  min, max = cups.min, cups.max

  iterations.times do |i|
    puts "#{(Time.local - start).total_seconds}s #{i}" if i % 1000 == 0
    current_cup = cups.shift
    three_cups = [
        cups.shift,
        cups.shift,
        cups.shift,
    ]

    destination = current_cup
    until destination != current_cup && !three_cups.includes?(destination)
      destination -= 1
      destination = max if destination < min
    end

    destination_index = cups.index(destination).not_nil!
    cups.insert destination_index + 1, three_cups[2]
    cups.insert destination_index + 1, three_cups[1]
    cups.insert destination_index + 1, three_cups[0]
    cups.push(current_cup)
  end

  until cups.first == 1
    cups.rotate!
  end

  cups
end

cups_part_1 = solve(cups.dup, 100)
puts "part 1 cups=#{cups_part_1}"

# min, max = cups.min, cups.max

cups_part_2 = solve(cups.dup + Deque.new((10..1_000_000).map(&.to_i)), 10_000_000)

puts "part 2 slice=[#{cups_part_2[0]}, #{cups_part_2[1]}, #{cups_part_2[2]}]"
puts "part 2 ans=#{cups_part_2}"
