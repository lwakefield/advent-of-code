require "./node.cr"

numbers = File.read_lines("day_10.txt").map(&.to_i).sort

differentials = {} of Int32 => Int32
([0] + numbers + [numbers.last + 3]).each_cons(2) do |pair|
  diff = pair[1] - pair[0]
  differentials[diff] ||= 0
  differentials[diff] += 1
end

puts differentials[1] * differentials[3]

# def get_chains(chain : Array(Int32), choices : Array(Int32))
#   next_chains = choices.select do |c|
#     c >= chain.last + 1 && c <= chain.last + 3
#   end.map do |c|
#     chain + [c]
#   end

#   res = [] of Array(Int32)
#   next_chains.each do |next_chain|
#     res += get_chains(next_chain, choices)
#   end

#   res.empty? ? [chain] : res
# end
# puts get_chains([0], numbers).select { |c| c.last == numbers.max }.size

alias Node = Nodes::DAGNode(Int32)
node_cache = {} of Int32 => Node
([0] + numbers + [numbers.max + 3]).each do |n|
  node_cache[n] = Node.new(n)
end
node_cache.values.each do |n|
  [
    node_cache[n.value + 1]?,
    node_cache[n.value + 2]?,
    node_cache[n.value + 3]?,
  ].compact.each do |child|
    node_cache[n.value] << child
  end
end

def combinations(node, target, combinations_cache = {} of Node => Int64)
  if combinations_cache[node]?
    return combinations_cache[node]
  end

  if node == target
    combinations_cache[node] = 1
    return combinations_cache[node]
  end

  res = node.children.map do |n|
    combinations(n, target, combinations_cache)
  end.sum

  combinations_cache[node] = res

  res
end

puts combinations(node_cache[0], node_cache[numbers.max])
