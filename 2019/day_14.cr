dependencies = {} of String => String

record Recipe,
	output_name : String,
	output_quantity : Int64,
	inputs : Array(Tuple(String, Int64))

recipes = {} of String => Recipe

File.each_line(ARGV[0]) do |line|
	dependencies[line.match(/\w+$/).not_nil![0]] = line

	inputs, outputs = line.split(" => ")
	output_quantity, output_name = outputs.split(" ")

	recipe = Recipe.new(
		output_name,
		output_quantity.to_i64,
		inputs.split(", ").map(&.split(" ")).map{ |v| Tuple.new(v[1], v[0].to_i64) }
	)
	recipes[output_name] = recipe
end

class Ship
	getter resources = {} of String => Int64

	def initialize (@recipes = {} of String => Recipe)
	end

	def produce (name, quantity)
		@resources[name] = 0 unless @resources[name]?
		return if name == "ORE"

		# puts "working on #{name} #{quantity}"

		recipe = @recipes[name]
		# parts, produced = @recipes[name]
		# produced_quantity = produced.split(" ").first.to_i64
		produced_quantity = recipe.output_quantity
		required = recipe.inputs

		# required : Array(Tuple(String, Int64)) = parts
		# 	.split(", ")
		# 	.map(&.split(" "))
		# 	.map{ |v| Tuple.new(v[1], v[0].to_i64) }

		# we increasing the amount in our bank until it is at least
		# quantity. we make one at a time. if we don't have enough
		# resources to make one, we produce those resources. every time
		# we produce a resource, we spend it immediately, otherwise
		# producing other resources might take them

		until @resources.fetch(name, 0) >= quantity
			required.each do |req_name, req_quantity|
				self.produce(req_name, req_quantity)
				@resources[req_name] -= req_quantity
			end

			# puts @resources
			# puts "produced #{name}"
			@resources[name] += produced_quantity
			# puts @resources
		end
	end
end

ship = Ship.new(recipes)

fuel_usage = 0.to_i64
while -ship.resources.fetch("ORE", 0) < 1e12
	ship.produce("FUEL", 1)
	fuel_usage += 1
	ship.resources["FUEL"] -= 1

	# is_cycle = ship.resources.all? do |key, val|
	# 	key == "ORE" || val == 0
	# end
	# if is_cycle
	# 	puts "cycle at fuel: #{fuel_usage} #{ship.resources["ORE"]}"
	# end

	if fuel_usage % 1000 == 0
		puts (-ship.resources.fetch("ORE", 0) / 1e12)
	end
end
puts fuel_usage
