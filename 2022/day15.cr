scanners_beacons = STDIN.gets_to_end.lines.map do |l|
	ax, ay, bx, by = l.scan(/\d+/).map(&.[0].to_i32)
	{ ax, ay, bx, by }
end

# this doesn't work great for beacons that are far from scanners
# it is slow and takes up a lot of memory
alias Pos = Tuple(Int32, Int32)
# map = {} of Pos => Char
# scanners_beacons.each do |ax, ay, bx, by|
# 	# puts({ax,ay,bx,by})
# 	d = (ax-bx).abs + (ay-by).abs
# 	((ax-d)..(ax+d)).each do |x|
# 		((ay-d)..(ay+d)).each do |y|
# 			next unless ((ax-x).abs+(ay-y).abs) <= d
# 
# 			map[{x,y}] = '#'
# 		end
# 		map[{ax,ay}] = 'S'
# 		map[{bx,by}] = 'B'
# 	end
# end
# min_x = map.keys.map(&.[0]).min
# max_x = map.keys.map(&.[0]).max
# min_y = map.keys.map(&.[1]).min
# max_y = map.keys.map(&.[1]).max
# 
# w = max_x - min_x + 1
# h = max_y - min_y + 1
# grid = [] of Array(Char)
# h.times do
# 	grid << [' '] * w
# end
# map.each do |k, v|
# 	x, y = k
# 	grid[y-min_y][x-min_x] = v
# end
# puts({min_x,min_y})
# puts grid.map(&.join).join("\n")
# exit

# we only want to calculate a single row, so... let's do that!
# map = {} of Pos => Char
# target_y = 2_000_000
# scanners_beacons.each do |ax, ay, bx, by|
# 	puts({ax, ay, bx, by})
# 	d = (ax-bx).abs + (ay-by).abs
# 
# 	next unless ((ay-d)..(ay+d)).includes?  target_y
# 
# 	((ax-d)..(ax+d)).each do |x|
# 		next unless (ax-x).abs+(ay-target_y).abs <= d
# 
# 		map[{x, target_y}] = '#'
# 	end
# end
# scanners_beacons.each do |ax, ay, bx, by|
# 	map[{ax,ay}] = 'S' if ay == target_y
# 	map[{bx,by}] = 'B' if by == target_y
# end
# puts "part 1: #{map.values.reject('B').size}"

def tuning_frequency (x, y)
	x.to_u64 * 4_000_000u64 + y.to_u64
end

map = {} of Int32 => Set(Range(Int32,Int32))
scanners_beacons.each do |ax, ay, bx, by|
	d = (ax-bx).abs + (ay-by).abs
	(((ay-d)..(ay+d))).each do |y|
		map[y] ||= Set(Range(Int32,Int32)).new
		dx = d-(ay-y).abs
		map[y] << ((ax-dx)..(ax+dx))
	end
	puts({ax, ay, bx, by})
end

# what if we combine all the rows and then find the one that can't be reduced
# all the way?
#
# 0  3
#  12
#
puts "start"
map = map.transform_values do |v|
	v.to_a.sort do |a,b|
		a.begin <=> b.begin
	end.reduce(Array(Range(Int32,Int32)).new) do |acc, v|
		if acc.empty?
			acc << v
		else
			if acc.last.includes? v.begin
				last = acc.pop
				acc << (last.begin..Math.max(last.end,v.end))
			else
				acc << v
			end
		end
		acc
	end
end
puts "stop"
# pp map[2_000_000].map(&.size).sim
# pp map.select{|k, v| (0..4_000_000).includes?(k) && v.size > 1}
map.each do |y, v|
	next unless (0..4_000_000).includes?(y)
	next unless v.size > 1

	v.each_cons(2) do |pair|
		left, right = pair
		if right.begin - left.end == 2
			puts y
			puts pair
			puts({left.end+1,y})
			puts tuning_frequency(left.end+1, y)
		end
	end
end
exit

# (0..4_000_000).each do |x|
# 	# puts x
# 	(0..4_000_000).each do |y|
# 		next if map[y].find{|r| r.includes? x}
# 		puts "part 2: #{tuning_frequency(x, y)}"
# 		exit
# 	end
# end

# 17936875503832 is too high

