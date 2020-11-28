def get_fuel_for_mass (mass : Int64)
	Math.max(0, (mass / 3).floor - 2).to_i64
end

total = 0
STDIN.each_line do |line|
	fuel_needed_for_module = get_fuel_for_mass( line.to_i64 )

	fuel_for_fuel = get_fuel_for_mass( fuel_needed_for_module )
	fuel_needed_for_module += fuel_for_fuel
	while fuel_for_fuel > 0
		fuel_for_fuel = get_fuel_for_mass( fuel_for_fuel )
		fuel_needed_for_module += fuel_for_fuel
	end

	total += fuel_needed_for_module
end


puts total
