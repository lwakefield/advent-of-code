require "./vec"

alias Map = Hash(Vec2, Char)
alias MapPath = Array(Vec2)
alias Graph = Hash(Vec2, Set(Vec2))
alias State = NamedTuple(pos: Vec2, has_keys: Set(Char), needs_keys: Set(Char))
alias State2 = NamedTuple(pos: Array(Vec2), has_keys: Set(Char), needs_keys: Set(Char))
alias World = NamedTuple(map: Map, points_of_interest: Hash(Char, Vec2),paths: Hash(Tuple(Vec2, Vec2), MapPath))

map = Map.new
File.read(ARGV[0]).lines.each_with_index do |line, y|
	line.each_char_with_index do |char, x|
		map[Vec2.new(x, y)] = char
	end
end

points_of_interest = map.invert
points_of_interest.delete('.')
points_of_interest.delete('#')
start_points = map.select{ |k, v| v == '@'}.keys

all_paths = {} of Tuple(Vec2, Vec2) => MapPath
(points_of_interest.values + start_points).permutations(2).each do |pair|
	start, stop = pair
	path = get_path?(start, stop, map, [start])
	next unless path
	all_paths[{start, stop}] = path
end

# pp all_paths
# puts map_to_s map

state = State2.new( pos: start_points, has_keys: Set(Char).new, needs_keys: points_of_interest.keys.select(&.ascii_lowercase?).to_set )
world = World.new( map: map, points_of_interest: points_of_interest, paths: all_paths )
puts solve(state, world)[state].size

def solve(state : State2, world : World, soln_cache = Hash(State2, MapPath).new): Hash(State2, MapPath)
	# puts world[:map][state[:pos]]
	# read_line

	if soln = soln_cache[state]?
		return soln_cache
	end

	pos, has_keys, needs_keys = state.values
	map, points_of_interest, paths = world.values

	if needs_keys.empty?
		soln_cache[state] = [ ] of Vec2
		return soln_cache
	end


	next_paths = [] of { Char, MapPath }
	pos.each do |p|
		needs_keys.each do |key_name|
			key_pos = points_of_interest[key_name]
			next unless paths[{p, key_pos}]?
			next_paths << { key_name, paths[{p, key_pos}] }
		end
	end
	next_paths = next_paths.select do |pair|
		key_name, path = pair
		path.all? do |pos|
			val = map[pos]
			!val.ascii_uppercase? || (val.ascii_uppercase? && has_keys.includes?(val.downcase))
		end
	end

	best_soln = nil
	next_paths.each do |key_name, path|
		next_pos = pos.clone
		next_pos[next_pos.index(path.first).not_nil!] = path.last
		next_state = State2.new(
			pos: next_pos,
			has_keys: has_keys | [key_name].to_set,
			needs_keys: needs_keys - [key_name].to_set
		)
		solve(next_state, world, soln_cache)
		soln = path[...-1] + soln_cache[next_state]
		if best_soln.nil? || best_soln.size > soln.size
			best_soln = soln
		end
	end
	soln_cache[state] = best_soln.not_nil!

	soln_cache
end

def map_to_s (map : Map)
	max_x = map.keys.map(&.x).max
	max_y = map.keys.map(&.y).max
	(0..max_y).map do |y|
		(0..max_x).map do |x|
			map[Vec2.new(x, y)]
		end.join
	end.join('\n')
end

def get_path? (start : Vec2, stop : Vec2, map : Map, path : MapPath): MapPath?
	if start == stop
		return path
	end

	neighbors = [
		start + Vec2.up,
		start + Vec2.down,
		start + Vec2.left,
		start + Vec2.right,
	].select { |p| map[p]? && map[p] != '#' && !path.includes?(p) }
	return nil if neighbors.empty?

	paths = neighbors.map { |p| get_path?(p, stop, map, path + [p]) }.compact
	return nil if paths.empty?
	paths.min_by(&.size)
end

def get_path (start : Vec2, stop : Vec2, map : Map, path : MapPath): MapPath
	get_path?(start, stop, map, path).not_nil!
end
