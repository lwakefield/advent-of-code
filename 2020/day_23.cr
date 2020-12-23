cups = ( ARGV.first? || "523764819" ).chars.map(&.to_i)

min, max = cups.min, cups.max

100.times do
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
puts "part 1 cups=#{cups} ans=#{(cups[one_index+1...] + cups[...one_index]).join}"
