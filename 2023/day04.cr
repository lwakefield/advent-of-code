puts "Part 1: #{(File.read ARGV.first).lines.map do |c|
        left, right = c.split(":")[1].split("|")
            .map(&.split.reject(&.empty?))
            .map(&.to_set)

    winners = left & right
    winners.empty? ? 0 : 2 ** (winners.size - 1)
end.sum}"

cards = {} of Int32 => Int32
(File.read ARGV.first).lines.each do |c|
    idx = c.match(/Card\s+(\d+)/).not_nil![1].to_i
    cards[idx] ||= 0
    cards[idx] += 1

    left, right = c.split(":")[1].split("|")
        .map(&.split.reject(&.empty?))
        .map(&.to_set)

    winners = left & right
    (idx+1..idx+winners.size).each do |i|
        cards[i] ||= 0
        cards[i] += cards[idx]
    end
end
puts "Part 2: #{cards.values.sum}"
