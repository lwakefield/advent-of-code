world = File.read(ARGV[0]).strip.lines.map(&.strip).reject(&.empty?)

def live (world : Array(String))
	world.map_with_index do |line, y|
		line.chars.map_with_index do |char, x|
			neighbors = [] of Char
			neighbors << world[y - 1][x] if y > 0
			neighbors << world[y + 1][x] if y < world.size - 1
			neighbors << world[y][x - 1] if x > 0
			neighbors << world[y][x + 1] if x < line.size - 1

			if char == '.'
				if [1, 2].includes? neighbors.select('#').size 
					'#'
				else
					'.'
				end
			else
				if neighbors.select('#').size == 1
					'#'
				else
					'.'
				end
			end
		end.join
	end
end

# p1
# seen = [world].to_set
# loop do
# 	world = live(world)
# 	break if seen.includes? world
# 	seen.add world
# end
# 
# puts world.join('\n')
# puts bio_score(world)

def live_cell (cell, neighbors)
	if cell == '.'
		if [1, 2].includes? neighbors.select('#').size 
			'#'
		else
			'.'
		end
	else
		if neighbors.select('#').size == 1
			'#'
		else
			'.'
		end
	end
end

def get_neighbors (pos, world : Array(String), parent : Array(String), child : Array(String))
	x, y = pos
	up    = {x, y - 1}
	down  = {x, y + 1}
	left  = {x - 1, y}
	right = {x + 1, y}

	neighbors = [] of Char
	if up[1] == -1
		neighbors << parent[1][2]
	elsif up == { 2, 2 }
		neighbors += child[4].chars
	else
		neighbors << world[up[1]][up[0]]
	end

	if down[1] == 5
		neighbors << parent[3][2]
	elsif down == { 2, 2 }
		neighbors += child[0].chars
	else
		neighbors << world[down[1]][down[0]]
	end

	if left[0] == -1
		neighbors << parent[2][1]
	elsif left == { 2, 2 }
		neighbors += child.map(&.chars.last)
	else
		neighbors << world[left[1]][left[0]]
	end

	if right[0] == 5
		neighbors << parent[2][3]
	elsif right == { 2, 2 }
		neighbors += child.map(&.chars.first)
	else
		neighbors << world[right[1]][right[0]]
	end

	neighbors
end

def live2 (world : Array(String), parent : Array(String), child : Array(String))
	new_world = world.clone

	(0...5).map do |y|
		(0...5).map do |x|
			next '?' if {x, y} == {2, 2}
			live_cell(
				world[y][x],
				get_neighbors({x, y}, world, parent, child)
			)
		end.join
	end
end

def bio_score (world : Array(String))
	score = 0
	world.join.chars.each_with_index do |c, index|
		next unless c == '#'
		score += 2 ** index
	end
	score
end

levels = {} of Int32 => Array(String)
(-10000..10000).each do |n|
	levels[n] = [
		".....",
		".....",
		"..?..",
		".....",
		".....",
	]
end
levels[0] = world

(1..200).each do |n|
	new_levels = levels.clone
	(-n..n).each do |i|
		new_levels[i] = live2(levels[i], levels[i-1], levels[i+1])
	end
	levels = new_levels
end

count = 0i64
levels.each do |level|
	c = level.join.chars.select('#').size
	count += c
end
puts count
