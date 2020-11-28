width, height = ARGV.first.split('x').map(&.to_i)
input = STDIN.gets_to_end.strip

alias Layer = Array(Array(Int32))
layers = Array(Layer).new
input.chars.each_slice( width * height) do |flat_layer|
	layer = Layer.new
	flat_layer.each_slice( width ) do |row|
		layer << row.map(&.to_i)
	end
	layers << layer
end

if ARGV.includes? "--solve=1"
	target = layers.sort do |a, b|
		a_count = a.flatten.select { |v| v == 0 }.size
		b_count = b.flatten.select { |v| v == 0 }.size
		a_count - b_count
	end.first
	puts target.flatten.select(&.== 1).size * target.flatten.select(&.== 2).size
elsif ARGV.includes? "--solve=2"
	result = Layer.new
	height.times do
		result << [2] * width
	end
	layers.reverse.each do |layer|
		layer.each_with_index do |row, y|
			row.each_with_index do |val, x|
				result[y][x] = val unless val == 2
			end
		end
	end
	message =  result.map do |row|
		row.map do |val|
			if val == 1
				"█"
			else
				" "
			end
		end.join
	end.join("\n")
	puts message
end
