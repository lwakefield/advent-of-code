id_ranges, ids = STDIN.gets_to_end.split("\n\n").map(&.lines)
id_ranges = id_ranges.map do |r|
    l, r = r.split("-").map(&.to_u64)
    (l..r)
end
ids = ids.map(&.to_u64)

fresh_ids = ids.select do |id|
    id_ranges.find(&.includes? id)
end
puts "part 1: #{fresh_ids.size}"

# fresh_ids = Set(UInt64).new
# id_ranges.each do |r|
#     r.each do |id|
#         fresh_ids << id
#     end
# end
# puts "part 2: #{fresh_ids.size}"

# ^^^ is going to be slow and run into memory problems
# we need to sort and combine the ranges...
num_fresh_ids = id_ranges.sort do |a, b|
    a.begin <=> b.begin
end.reduce([] of Range(UInt64, UInt64)) do |acc, curr|
    if acc.empty?
        acc << curr
    elsif acc.last.includes?(curr.begin) && acc.last.includes?(curr.end)
        # discard as it is already fully within range
    elsif acc.last.includes?(curr.begin) && !acc.last.includes?(curr.end)
        acc[-1] = (acc[-1].begin..curr.end)
    elsif !acc.last.includes?(curr.begin) && !acc.last.includes?(curr.end)
        acc << curr
    else
        raise "case should never happen"
    end
    acc
end.reduce(0u64) do |acc, curr|
    acc + (curr.end - curr.begin + 1)
end
puts "part 2: #{num_fresh_ids}"