require "./intcode.cr"

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)

instructions = "
west
north
take dark matter
south
south
east
# take photons
west
north
east
north
west
take planetoid
west
take spool of cat6
east
east
south
east
# take escape pod
north
east
# take giant electromagnet
west
take sand
west
take coin
north
take jam
south
west
# take infinite loop
south
take wreath
west
take fuel cell
east
north
north
# take molten lava
west
".strip.lines.reject(&.starts_with?('#'))

program = Program.new(input_program.clone)

STDOUT << program.read_fully.map(&.chr).join

instructions.each do |instr|
	STDOUT << "#{instr}\n"
	program.write instr
	program.write "\n"
	program.run
	STDOUT << program.read_fully.map(&.chr).join
end

all_items = [
	"coin",
	"jam",
	"fuel cell",
	"planetoid",
	"sand",
	"spool of cat6",
	"dark matter",
	"wreath"
]

all_combinations = [] of Array(String)
(1..all_items.size).each do |n|
	all_combinations += all_items.combinations(n)
end

all_combinations.each do |combination|
	all_items.each do |i|
		program.write "drop #{i}\n"
	end
	combination.each do |i|
		program.write "take #{i}\n"
	end
	program.write "south\n"
	program.run
	STDOUT << program.read_fully.map(&.chr).join
	read_line
end
puts all_combinations

until program.run == Signals::DONE
	STDOUT << program.read_fully.map(&.chr).join
	program.write read_line
	program.write "\n"
end







# Hall: dark matter | stables              | SB:planetoid  | WDM:cat6
# Nav               | HB                   | SL:escape pod |
# Arcade            | Corridor: photons    |





# Sick Bay: Planetoid
# Warp Drive Maintenance: Spool of Cat6
# Hallway: Darkmatter
# Corridor: Photons
# Science Lab: Escape  Pod
# Observatory: Sand
# Holodeck: Giant Electromagnet
# Crew Quarters: coin
# Gift Wrapping Center: infinite loop
# Kitchen: wreath
# Hot  Chocolate Fountain: fuel cell
# Engineering: molten lava
# Storage: jam

# Hull Breach -> Stables {North}
# Hull Breach -> Science Lab {East}
# Hull Breach -> Navigation {West}
# Stables -> Sick Bay {West}
# Sick Bay -> Warp Drive Maintenance {West}
# Navigation -> Hallway {North}
# Navigation -> Arcade {South}
# Arcade -> Corridor {East}
# Science Lab -> Observatory {North}
# Science Lab -> Passages {East}
# Observatory -> Holodeck {East}
# Observatory -> Crew Quarters {West}
# Crew Quarters -> Gift Wrapping Center {West}
# Crew Quarters -> Storage {North}
# Gift Wrapping Center -> Kitchen {South}
# Gift Wrapping Center -> Engineering {North}
# Engineering -> Security Checkpoint {West}
# Kitchen -> Hot Chocolate Fountain {West}
# Security Checkpoint -> Pressure-Sensitive Floor {South} !!!
