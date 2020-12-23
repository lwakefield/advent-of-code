require "time"
cups = ( ARGV.first? || "523764819" ).chars.map(&.to_i)

min, max = cups.min, cups.max

cups += ((max+1)..1_000_000).map(&.to_i)

start = Time.local
10_000_000.times do |i|
    puts "#{(Time.local - start).total_seconds}s #{i}" if i % 1000 == 0
    # puts cups
    current_cup = cups[0]
    three_cups = cups.delete_at 1..3
    # puts three_cups
    # puts cups
    destination = current_cup
    until current_cup != destination && cups.includes?(destination)
        destination -= 1
        destination = max if destination < min
    end
    # puts destination
    # read_line
    destination_index = cups.index(destination).not_nil!
    next_cups = (cups[0..destination_index] + three_cups + cups[destination_index+1..])
    cups = next_cups.rotate
end
one_index = cups.index(1).not_nil!
until cups.first == 0
    cups.rotate!
end
puts "part 2 slice=#{cups[0...3]}"
