require "./node"

alias BagNode = Nodes::Node(Int32, String)
alias Edge = Nodes::Edge(Int32, String)

node_cache = {} of String => BagNode

File.each_line(ARGV.first? || "./day_07.txt") do |line|
    parent_dsc, right = line.split(" bags contain ")
    children = right.scan(/(?<qty>\d+) (?<dsc>.+?) bag/)

    node_cache[parent_dsc] ||= BagNode.new(parent_dsc)
    parent = node_cache[parent_dsc]

    children.each do |child|
        qty = child["qty"].to_i
        dsc = child["dsc"]

        node_cache[dsc] ||= BagNode.new(dsc)
        edge = Edge.new(qty, parent, node_cache[dsc])

        parent << edge
        node_cache[dsc] << edge
    end
end

def parent_nodes (node)
    node.edges.select { |e| e.to == node }.map(&.from)
end

def child_edges (node)
    node.edges.select { |e| e.from == node }
end

my_bag = node_cache["shiny gold"]

# part 1

parents = parent_nodes(my_bag)
visited = Set(BagNode).new
until parents.empty?
    node = parents.pop
    visited.add(node)
    parents += parent_nodes(node)
end

puts visited.size

# part 2

def child_count (bag)
    bag_count = 0
    child_edges(bag).each do |edge|
        bag_count += edge.value + edge.value * child_count(edge.to)
    end
    bag_count
end

puts child_count(my_bag)
