class Node
	getter name : String
	getter children : Array(Node)
	getter parent : Node | Nil

	def initialize(@name, @children = [] of Node)
	end

	def << (child : Node)
		@children << child
		child.parent = self
	end

	protected def parent= (p : Node | Nil)
		@parent = p
	end

	def distance_to_root
		return 0 if @parent.nil?
		return @parent.not_nil!.distance_to_root + 1
	end

	def path_to_root
		return [ self ] if @parent.nil?
		return @parent.not_nil!.path_to_root + [ self ]
	end
end

node_map = { } of String => Node

STDIN.each_line do |line|
	big_body_name, small_body_name = line.split(')')

	if node_map.has_key?(big_body_name) == false
		node_map[big_body_name] = Node.new(big_body_name)
	end
	if node_map.has_key?(small_body_name) == false
		node_map[small_body_name] = Node.new(small_body_name)
	end

	big_body = node_map[big_body_name]
	small_body = node_map[small_body_name]

	big_body << small_body
end

if ARGV.empty?
	num_orbits = 0
	node_map.values.each do |node|
		num_orbits += node.distance_to_root
	end

	puts num_orbits

elsif ARGV.size == 2
	node_a, node_b = node_map[ARGV[0]], node_map[ARGV[1]]

	node_a_path_to_root = node_a.path_to_root
	node_b_path_to_root = node_b.path_to_root

	intersection_before = node_a_path_to_root.zip?(node_b_path_to_root).index do |nodes|
		left, right = nodes
		left != right
	end
	raise "no common path" if intersection_before.nil?

	puts node_a_path_to_root.size + node_b_path_to_root.size - (2 * intersection_before) - 2
end
