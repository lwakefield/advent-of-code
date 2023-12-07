puts "Part 1/2: #{(File.read ARGV.first)
    .split(/\n/)
    .reject(&.empty?)
    .map(&.split)
    .sort do |a, b|
        at, bt = get_type(a[0]), get_type(b[0])
        next at - bt if at != bt

        get_hand_card_strength(a[0]) - get_hand_card_strength(b[0])
    end.map_with_index do |hand, idx|
        hand[1].to_i * (idx + 1)
    end.sum}"

def get_type(hand)
    counts = hand.chars.reduce({} of Char => Int32) do |acc, i|
        acc[i] ||= 0
        acc[i] += 1
        acc
    end
    score = case { counts.values.sort, counts['J']? }
            when {     [5],         _   } then 6
            when {     [1,4],       nil } then 5
            when {     [2,3],       nil } then 4
            when {     [1,1,3],     nil } then 3
            when {     [1,2,2],     nil } then 2
            when {     [1,1,1,2],   nil } then 1
            when {     [1,1,1,1,1], nil } then 0

            # uncomment below for part 1
            when {     [1,4],       1   } then 6
            when {     [1,4],       4   } then 6

            when {     [2,3],       2   } then 6
            when {     [2,3],       3   } then 6

            when {     [1,1,3],     1   } then 5
            when {     [1,1,3],     3   } then 5

            when {     [1,2,2],     1   } then 4
            when {     [1,2,2],     2   } then 5

            when {     [1,1,1,2],   1   } then 3
            when {     [1,1,1,2],   2   } then 3

            when {     [1,1,1,1,1], 1   } then 1

            else raise "err"
            end

    score
end

def get_hand_card_strength (hand)
    hand.chars.reduce(0) do |acc, i|
        acc += get_card_strength i
        acc = acc << 4
        acc
    end >> 4
end

def get_card_strength(card)
    case card
    when 'T' then 10
    # when 'J' then 11 # part 1
    when 'J' then 0 # part 2
    when 'Q' then 12
    when 'K' then 13
    when 'A' then 14
    when .ascii_number? then card.to_i
    else raise "err" end
end
