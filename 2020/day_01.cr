numbers = File.read_lines("day_01.txt").map(&.to_i)

numbers.each_combination(2) do |combination|
    if combination.sum == 2020
        puts "part 1: #{combination.join(" + ")} = 2020"
        puts "part 1: #{combination.join(" * ")} = #{combination.product}"
    end
end

numbers.each_combination(3) do |combination|
    if combination.sum == 2020
        puts "part 2: #{combination.join(" + ")} = 2020"
        puts "part 2: #{combination.join(" * ")} = #{combination.product}"
    end
end
