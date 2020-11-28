record Vec2,
	x : Int32,
	y : Int32
struct Vec2
	def + (other : Vec2)
		Vec2.new(@x + other.x, @y + other.y)
	end
	def * (val : Int32)
		Vec2.new(val * @x, val * @y)
	end
	def - (other : Vec2)
		Vec2.new(@x - other.x, @y - other.y)
	end
	def sign
		Vec2.new(@x.sign, @y.sign)
	end
	def l2
		Math.sqrt(@x ** 2 + @y ** 2)
	end
	def to_vec3
		Vec3.new(@x, @y, 0)
	end
	def self.zero
		Vec2.new(0, 0)
	end
	def self.up
		Vec2.new(0, -1)
	end
	def self.down
		Vec2.new(0, 1)
	end
	def self.left
		Vec2.new(-1, 0)
	end
	def self.right
		Vec2.new(1, 0)
	end
	def self.dirs
		[up, down, left, right]
	end
end

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
	def l2
		Math.sqrt(@x ** 2 + @y ** 2 + @z ** 2)
	end
	def to_vec2
		Vec2.new(@x, @y)
	end
	def self.zero
		Vec3.new(0, 0, 0)
	end
end
