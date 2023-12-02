require "file"

possible_sum = 0
(File.read ARGV.first).lines.each do |l|
    id = l.match(/(?<=Game )\d+/).not_nil![0].to_i32
    is_possible = l.split(": ")[1].split(";").all? do |set|
        set.scan(/(\d+) (\w+)/).all? do |m|
            case m[2]
            when "red"   then m[1].to_i <= 12
            when "green" then m[1].to_i <= 13
            when "blue"  then m[1].to_i <= 14
            else raise "err"
            end
        end
    end
    possible_sum += id if is_possible
end
puts "Part 1: #{possible_sum}"

power = 0
(File.read ARGV.first).lines.each do |l|
    id = l.match(/(?<=Game )\d+/).not_nil![0].to_i32
    r, g, b = 0, 0, 0
    l.split(": ")[1].split(";").all? do |set|
        set.scan(/(\d+) (\w+)/).all? do |m|
            case m[2]
            when "red"   then r = Math.max(m[1].to_i, r)
            when "green" then g = Math.max(m[1].to_i, g)
            when "blue"  then b = Math.max(m[1].to_i, b)
            else raise "err"
            end
        end
    end
    power += r * g * b
end
puts "Part 2: #{power}"