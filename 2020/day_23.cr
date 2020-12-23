require "time"
cups = (ARGV.first? || "523764819").chars.map(&.to_i)

class LinkedList
  @lut = {} of Int32 => LinkedListNode
  getter front : LinkedListNode?
  getter back : LinkedListNode?

  def unshift(node)
    if !front
      @back = node
      @front = node
      return
    end

    @front.not_nil!.left = node
    node.right = @front
    @front = node

    @back = @front if @back.nil?
  end

  def push(node)
    if !back
      @back = node
      @front = node
      return
    end

    @back.not_nil!.right = node
    node.left = @back
    @back = node
  end

  def shift
    node = @front.not_nil!
    node.right.not_nil!.left = nil if node.right
    @front = node.right
    node.right = nil
    node.left = nil
    node
  end

  def each
    node = @front
    while node
      yield node
      node = node.right
    end
  end

  def insert_right (node, to_insert)
    node.right.not_nil!.left = to_insert if node.right
    to_insert.right = node.right
    to_insert.left = node
    node.right = to_insert

    @back = to_insert if to_insert.right.nil?
  end

  def rotate!
    push(shift)
  end
end

class LinkedListNode
  property left : LinkedListNode?
  property right : LinkedListNode?
  getter val

  def initialize(@val : Int32)
  end
end

def solve(cups : LinkedList, range, iterations)
  start = Time.local
  lut = {} of Int32 => LinkedListNode
  cups.each do |n|
    lut[n.val] = n
  end

  iterations.times do |i|
    puts "#{(Time.local - start).total_seconds}s #{i}" if i % 1000 == 0
    current_cup = cups.shift
    three_cups = [
      cups.shift,
      cups.shift,
      cups.shift,
    ]
    three_cup_vals = three_cups.map(&.val)

    destination_val = current_cup.val
    until destination_val != current_cup.val && !three_cup_vals.includes?(destination_val)
      destination_val -= 1
      destination_val = range.end if destination_val < range.begin
    end

    destination = lut[destination_val]
    cups.insert_right destination, three_cups[2]
    cups.insert_right destination, three_cups[1]
    cups.insert_right destination, three_cups[0]
    cups.push(current_cup)
  end

  until cups.front.not_nil!.val == 1
    cups.rotate!
  end

  cups
end

cups_part_1 = LinkedList.new
cups.each do |n|
  cups_part_1.push(LinkedListNode.new(n))
end

solve(cups_part_1, (1..9), 100)
res = [] of Int32
cups_part_1.each do |n|
    res << n.val
end

puts "part 1 cups=#{res}"

cups_part_2 = LinkedList.new
cups.each do |n|
  cups_part_2.push(LinkedListNode.new(n))
end
(10..1_000_000).each do |n|
  cups_part_2.push(LinkedListNode.new(n))
end
solve(cups_part_2, (1..1_000_000), 10_000_000)

res = [] of Int32
cups_part_2.each do |n|
    res << n.val
end

puts "part 2 cups=#{res[0..2]}"
