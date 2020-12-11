class Grid(T)
	@grid : Hash(Tuple(Int32, Int32), T)
	@width : Int32
	@height : Int32

	def initialize(@width : Int32, @height : Int32)
		@grid = Hash(Tuple(Int32, Int32), T).new
		@width.times do |x|
			@height.times do |y|
				@grid[{x, y}] = yield x, y
			end
		end
	end

	def []? (x : Int32, y : Int32)
		return nil if x < 0
		return nil if x >= @width
		return nil if y < 0
		return nil if y >= @height

		@grid[{x, y}]
	end

	def [] (x : Int32, y : Int32)
		val = self[x, y]?
		raise IndexError.new if val.nil?
		val
	end

	def []= (x : Int32, y : Int32, v : T)
		@grid[{x,y}] = v
	end

	def each
		@height.times do |y|
			@width.times do |x|
				yield x, y, self[x, y]
			end
		end
	end

	def clone
		Grid(T).new(@width, @height) do |x, y|
			self[x, y]
		end
	end

	def to_s (io : IO)
		@height.times do |y|
			@width.times do |x|
				io << self[x, y]
			end
			io << '\n'  if y != @height - 1
		end
	end
end
