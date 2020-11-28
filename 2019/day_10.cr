alias Grid = Array(Array(Char))
alias Point = Tuple(Int32, Int32)

def distance (point_a : Point, point_b : Point)
	Math.sqrt ((point_a[0] - point_b[0]) ** 2) + ((point_a[1] - point_b[1]) ** 2)
end

grid = Grid.new
STDIN.each_line do |line|
	grid << line.chars
end

asteroids = Set(Point).new
grid.each_with_index do |row, y|
	row.each_with_index do |val, x|
		asteroids.add({x, y}) if val == '#'
	end
end

collision_sets = {} of Point => Hash(Point, Set(Point))
asteroids.each do |origin|
	asteroids.each do |point_b|
		next if origin == point_b

		delta = { point_b[0] - origin[0], point_b[1] - origin[1] }
		gcd = delta[0].gcd(delta[1])
		delta = { delta[0] / gcd, delta[1] / gcd }

		collision_sets[origin] = {} of Point => Set(Point) unless collision_sets[origin]?
		collision_sets[origin][delta] = Set(Point).new unless collision_sets[origin][delta]?
		collision_sets[origin][delta].add point_b
	end
end

if ARGV.includes? "--solve=1"
	collisions = collision_sets.to_a.sort do |left, right|
		right[1].size - left[1].size
	end.first

	puts "origin: #{collisions[0]} observable: #{collisions[1].size}"

elsif ARGV.includes? "--solve=2"
	x, y = ARGV[1].split(",").map(&.to_i32)
	origin = {x, y}

	asteroids = collision_sets[{x, y}].to_a.sort do |left, right|
		adj_a = left[0][0]
		opp_a = left[0][1]
		theta_a = Math.atan2(opp_a, adj_a) + 1.5 * Math::PI
		theta_a -= 2 * Math::PI if theta_a >= Math::PI

		adj_b = right[0][0]
		opp_b = right[0][1]
		theta_b = Math.atan2(opp_b, adj_b) + 1.5 * Math::PI
		theta_b -= 2 * Math::PI if theta_b >= Math::PI

		theta_a > theta_b ? 1 : -1
	end.map do |delta, collisions|
		collisions.to_a.sort do |left, right|
			distance(origin, left) > distance(origin, right) ? 1 : -1
		end
	end

	count = 1
	until asteroids.empty?
		asteroids.each_with_index do |ray, index|
			next if ray.empty?

			puts "Removing asteroid #{count} #{ray.first}"
			asteroids[index].delete_at(0)
			count += 1
		end
		asteroids = asteroids.reject(&.empty?)
	end

end
