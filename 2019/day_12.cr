record Vec3,
	x : Int32,
	y : Int32,
	z : Int32
struct Vec3
	def + (other : Vec3)
		Vec3.new(@x + other.x, @y + other.y, @z + other.z)
	end
	def - (other : Vec3)
		Vec3.new(@x - other.x, @y - other.y, @z - other.z)
	end
	def sign
		Vec3.new(@x.sign, @y.sign, @z.sign)
	end
	def self.zero
		Vec3.new(0, 0, 0)
	end
end

def lcm (arr : Array(Int))
	acc = arr[0].to_i64
	arr[1..].each do |v|
		acc = (acc * v) / acc.gcd(v)
	end
	return acc
end

def axis(val, axis)
	{ val[0][axis], val[1][axis] }
end

def simulate (planets : Array(Tuple(Vec3, Vec3)))
	planets.map do |planet_a|
		pos_a, vel_a = planet_a

		planets.each do |planet_b|
			next if planet_a == planet_b

			pos_b, _ = planet_b

			delta = pos_b - pos_a
			vel_a += delta.sign
		end

		{ pos_a + vel_a, vel_a }
	end
end

planets = [] of Tuple(Vec3, Vec3)
STDIN.each_line do |line|
	x, y, z = line.lchop.rchop.gsub(/\w=/, "").split(", ")
	planets << { Vec3.new(x.to_i, y.to_i, z.to_i), Vec3.zero }
end

if ARGV.includes? "--solve=1"
	1.upto(1000).each do
		planets = simulate planets
	end
	STDOUT << planets.sum do |pos, vel|
		(pos.x.abs + pos.y.abs + pos.z.abs) * (vel.x.abs + vel.y.abs + vel.z.abs)
	end
	STDOUT << "\n"
	exit
end

if ARGV.includes? "--solve=2"
	start_positions = planets.clone
	x_cycles_at : Int32 | Nil = nil
	y_cycles_at : Int32 | Nil = nil
	z_cycles_at : Int32 | Nil = nil

	step = 1
	loop do
		planets = planets.map do |planet_a|
			pos_a, vel_a = planet_a

			planets.each do |planet_b|
				next if planet_a == planet_b

				pos_b, _ = planet_b

				delta = pos_b - pos_a
				vel_a += delta.sign
			end

			{ pos_a + vel_a, vel_a }
		end

		if planets.map(&.map(&.x)) == start_positions.map(&.map(&.x)) && x_cycles_at.nil?
			x_cycles_at = step
		end
		if planets.map(&.map(&.y)) == start_positions.map(&.map(&.y)) && y_cycles_at.nil?
			y_cycles_at = step
		end
		if planets.map(&.map(&.z)) == start_positions.map(&.map(&.z)) && z_cycles_at.nil?
			z_cycles_at = step
		end

		if x_cycles_at && y_cycles_at && z_cycles_at
			puts lcm([x_cycles_at, y_cycles_at, z_cycles_at])
			exit
		end

		step += 1
	end
end
