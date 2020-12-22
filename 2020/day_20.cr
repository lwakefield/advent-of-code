class Tile
  getter cells
  @edges : Array(Array(String)) | Nil
  @variations : Array(Array(String)) | Nil
  getter neighbors = Set(Tile).new

  def initialize(@cells : Array(String))
  end

  def variations
    @variations ||= variations(@cells)
    @variations.not_nil!
  end

  def edges
    @edges ||= [
      edges(variations[0]),
      edges(variations[1]),
      edges(variations[2]),
    ]
    @edges.not_nil!
  end

  def variations_with_edges
    variations.zip(edges)
  end
end

def rot(cells : Array(String), n)
  n.times do
    cells = cells.map(&.chars).transpose.map(&.reverse.join)
  end
  cells
end

def flip_x(cells : Array(String))
  cells.map(&.reverse)
end

def flip_y(cells : Array(String))
  cells.reverse
end

def variations(cells : Array(String))
  [
    rot(cells, 0),
    rot(cells, 1),
    rot(cells, 2),
    rot(cells, 3),

    rot(flip_x(cells), 0),
    rot(flip_x(cells), 1),
    rot(flip_x(cells), 2),
    rot(flip_x(cells), 3),

    rot(flip_y(cells), 0),
    rot(flip_y(cells), 1),
    rot(flip_y(cells), 2),
    rot(flip_y(cells), 3),
  ]
end

def edges(cells : Array(String))
  [
    # top, right, bot, left
    cells.first,
    cells.map(&.char_at(-1)).join,
    cells.last,
    cells.map(&.char_at(0)).join,
  ]
end

def top(cells)
  cells.first
end

def right(cells)
  cells.map(&.char_at(-1)).join
end

def bot(cells)
  cells.last
end

def left(cells)
  cells.map(&.char_at(0)).join
end

tiles = {} of Int32 => Tile
File.read("./day_20.txt").split("\n\n").map(&.lines).reject(&.empty?).each do |lines|
  title = lines[0]
  tiles[title.match(/\d+/).not_nil![0].to_i] = Tile.new lines[1..]
end

# puts tiles.values.map(&.edges)
edge_map = {} of String => Set(Int32)
tiles.each do |id, t|
  t.edges.flatten.each do |e|
    edge_map[e] ||= Set(Int32).new
    edge_map[e].add id
  end
end
edge_map.each_value do |neighbors|
  neighbors.to_a.each_combination(2) do |pair|
    left, right = tiles[pair[0]], tiles[pair[1]]
    left.neighbors.add right
    right.neighbors.add left
  end
end
corners = tiles.select { |k, v| v.neighbors.size == 2 }
edges = tiles.select { |k, v| v.neighbors.size == 3 }

puts "part 1: #{corners.keys.map(&.to_u64).product}"

stitched = {
  {0, 0} => corners.values.first,
}
edge_positions = Array.new(12) { |i| {i, 0} } +
                 Array.new(11) { |i| {11, i + 1} } +
                 Array.new(11) { |i| {11 - i - 1, 11} } +
                 Array.new(10) { |i| {0, 11 - i - 1} }
edge_positions.each_cons(2) do |pair|
  last, curr = pair
  edge_neighbors = stitched[last].neighbors.select do |t|
    t.neighbors.size < 4 && !stitched.has_value?(t)
  end
  stitched[curr] = edge_neighbors.first
end

(1..10).each do |y|
  (1..10).each do |x|
    up = stitched[{x, y - 1}]
    left = stitched[{x - 1, y}]
    common_neighbors = (up.neighbors & left.neighbors).reject { |t| stitched.has_value? t }
    raise "expected one matching neighbor" unless common_neighbors.size == 1
    stitched[{x, y}] = common_neighbors.first
  end
end

# possible_variations = {} of Tuple(Int32, Int32) => Array(Array(String))
# stitched.each do |pos, tile|
#     possible_variations[pos] = tile.variations
# end

# def does_fit(tiles : Hash(Tuple(Int32,Int32), Array(String))
# size = tiles.size.sqrt
# end

alias Grid = Array(String)

def combinations_x(col : Array(Array(Grid))) : Array(Grid)
  return col.first if col.size == 1

  first_variations : Array(Grid) = col.first
  remaining_variations : Array(Grid) = combinations_x col[1..]

  res = [] of Grid

  first_variations.each do |left|
    remaining_variations.each do |right|
      res << join_x(left, right) if can_join_x(left, right)
    end
  end

  res
end

def combinations_y(row : Array(Array(Grid))) : Array(Grid)
  return row.first if row.size == 1

  first_variations : Array(Grid) = row.first
  remaining_variations : Array(Grid) = combinations_y row[1..]

  res = [] of Grid

  first_variations.each do |top|
    remaining_variations.each do |bot|
      res << join_y(top, bot) if can_join_y(top, bot)
    end
  end

  res
end

# first_row = (0...12).map { |i| stitched[{i, 0}].variations }
# rows = (0...12).map do |y|
#   combinations_x((0...12).map { |x| stitched[{x,y}].variations })
# end
# final = combinations_y(rows)
# puts final.size
# puts first_row
# puts combinations_x(first_row).size

# puts can_join_x(
#   %w(abc def ghi),
#   %w(ccc fff iii)
# )
# puts can_join_y(
#   %w(abc def ghi),
#   %w(ghi fff iii)
# )

# a  b  c  d  e  f
# g  h  i  j  k  l
# m  n  o  p  q  r
# s  t  u  v  w  x
# y  z  aa ab ac ad
# ae af ag ah ai aj

# a  a  b  b  c  c
# a  a  b  b  c  c
# d  d  e  e  f  f
# d  d  e  e  f  f
# g  g  h  h  i  i
# g  g  h  h  i  i

# a  a  a  a  b  b
# a  a  a  a  b  b
# a  a  a  a  b  b
# a  a  a  a  b  b
# c  c  c  c  d  d
# c  c  c  c  d  d

# chunks_1 = {} of Tuple(Int32,Int32) => Array(Array(String))
# (0...6).each do |y|
#   (0...6).each do |x|
#     # puts "#{{x*2,y*2}} #{{x*2+1,y*2}} #{{x*2,y*2+1}} #{{x*2+1,y*2+1}}"
#     chunks_1[{x,y}] = combinations(
#       stitched[{x*2, y*2}].variations,
#       stitched[{x*2+1, y*2}].variations,
#       stitched[{x*2, y*2+1}].variations,
#       stitched[{x*2+1, y*2+1}].variations,
#     )
#   end
# end
# puts "#{chunks_1.size} #{chunks_1.values.map(&.size).sum}"
# chunks_2 = {} of Tuple(Int32,Int32) => Array(Array(String))
# (0...3).each do |y|
#   (0...3).each do |x|
#     # puts "#{{x*2,y*2}} #{{x*2+1,y*2}} #{{x*2,y*2+1}} #{{x*2+1,y*2+1}}"
#     chunks_2[{x,y}] = combinations(
#       chunks_1[{x*2, y*2}],
#       chunks_1[{x*2+1, y*2}],
#       chunks_1[{x*2, y*2+1}],
#       chunks_1[{x*2+1, y*2+1}],
#     )
#   end
# end
# puts "#{chunks_2.size} #{chunks_2.values.map(&.size).sum}"
# chunks_3 = {} of Tuple(Int32,Int32) => Array(Array(String))
# chunks_3[{0,0}] = combinations(
#   chunks_2[{0,0}],
#   chunks_2[{1,0}],
#   chunks_2[{0,1}],
#   chunks_2[{1,1}],
# )
# chunks_3[{1,0}] = combinations_y(
#   chunks_2[{2,0}],
#   chunks_2[{2,1}],
# )
# chunks_3[{0,1}] = combinations_x(
#   chunks_2[{0,2}],
#   chunks_2[{1,2}],
# )
# chunks_3[{1,1}] = chunks_2[{2,2}]
# puts "#{chunks_3.size} #{chunks_3.values.map(&.size).sum}"
# # # puts chunks_2[{0,0}].size
# # # puts chunks_2[{1,0}].size
# # # puts chunks_2[{0,1}].size
# # # puts chunks_2[{1,1}].size
# final = combinations(
#   chunks_2[{0, 0}],
#   chunks_2[{1, 0}],
#   chunks_2[{0, 1}],
#   chunks_2[{1, 1}],
# )
# puts final.first.join("\n")
# puts final.first.map(&.join("\n"))

# combinations(
#   stitched[{x*2, y*2}].variations,
#   stitched[{x*2+1, y*2}].variations,
#   stitched[{x*2, y*2+1}].variations,
#   stitched[{x*2+1, y*2+1}].variations,
# )
# chunks_2 = [] of Array(Array(String))
# chunks_2 <<
#     chunks_1 << combinations(
#       stitched[{x*2, y*2}].variations,
#       stitched[{x*2+1, y*2}].variations,
#       stitched[{x*2, y*2+1}].variations,
#       stitched[{x*2+1, y*2+1}].variations,
#     )
# a = combinations(a, b, g, h)
# puts a.size

def combinations(a, b, c, d)
  res = [] of Array(String)
  a.each do |av|
    b.each do |bv|
      c.each do |cv|
        d.each do |dv|
          if right(av) == left(bv) &&
             bot(bv) == top(dv) &&
             left(dv) == right(cv) &&
             top(cv) == bot(av)
            res << join_y(
              join_x(av, bv),
              join_x(cv, dv)
            )
          end
        end
      end
    end
  end
  res
end

def combinations_y(a, b)
  res = [] of Array(String)
  a.each do |av|
    b.each do |bv|
      if bot(av) == top(bv)
        res << join_y(av, bv)
      end
    end
  end
  res
end

def combinations_x(a, b)
  res = [] of Array(String)
  a.each do |av|
    b.each do |bv|
      if right(av) == left(bv)
        res << join_x(av, bv)
      end
    end
  end
  res
end

def can_join_x(a, b)
  right(a) == left(b)
end

def can_join_y(a, b)
  bot(a) == top(b)
end

def join_x(a, b)
  (0...a.size).map do |i|
    a[i] + b[i]
  end
end

def join_x(row)
  (0...row.first.size).map do |y|
    row.map {|r| r[y] }.flatten
  end
end

def join_y(a, b)
  a + b
end

# stitched[{0,0}].edges.map(&.to_set).each do |e1|
#     stitched[{1,0}].edges.map(&.to_set).each do |e2|
#         puts e1 & e2
#     end
# end
# a = stitched[{0, 0}]
# b = stitched[{1, 0}]
# c = stitched[{0, 1}]
# d = stitched[{1, 1}]
# # possible_variations = {} of Tuple(Int32, Int32)
# a.variations.each do |av|
#   b.variations.each do |bv|
#     c.variations.each do |cv|
#       d.variations.each do |dv|
#         puts fit(av, bv, cv, dv)
#       end
#     end
#   end
# end

def fit(a, b, c, d)
  # a b
  # c d
  a_edge = edges(a)
  b_edge = edges(b)
  c_edge = edges(c)
  d_edge = edges(d)
  a_edge[1] == b_edge[3] &&
    b_edge[2] == d_edge[0] &&
    d_edge[3] == c_edge[1] &&
    c_edge[0] == a_edge[2]
end

# 12.times
# (1..11).each do |x|
#     last = stitched[{x-1, 0}]
#     neighbors = last.neighbors.select{ |t| t.neighbors.size < 4 }
#     stitched[{x,0}] = neighbors.first
# end
# (1..11).each do |y|
#     last = stitched[{11, y-1}]
#     neighbors = last.neighbors.select{ |t| t.neighbors.size < 4 }
#     stitched[{x,0}] = neighbors.first
# end

# corner_ids = Set(Int32).new
# edge_ids = Set(Int32).new
# tiles.each do |id, t|
#     t.edges.each do |edges|
#         no_match_count = 0
#         edges.each do |edge|
#             no_match_count += 1 if edge_map[edge].size == 1
#         end
#         corner_ids.add id if no_match_count == 2
#         edge_ids.add id if no_match_count >= 1
#     end
# end

# puts "part 1: #{corner_ids.to_a.map(&.to_u64).product}"

# linked_edges = [corner_ids.first]
# until linked_edges.size == edge_ids.size
#    tile = tiles[linked_edges.last]
#    tile.edges.flatten.uniq.find do |e|
#        edge_map[e]
#    end
#    # edge_ids.find do |candidate_id|
#    #     tiles[candidate_id].edges.to_set.intersects?
#    # end
#    # tiles[linked_edges.last].edges
# end

# stitched = [[nil]*12]*12
# stitched = {} of Tuple(Int32, Int32) => Int32

# stitched[{0,0}] = corner_1

# corner_1 = corner_ids.first
# tiles[corner_1].edges.each do |edges|
#     candidates = edges.map do |edge|
#         edge_map[edge] & edge_ids
#     end.reject(&.empty?)
#     puts candidates
# end

# puts corner_ids.size
# puts edge_ids.size

# edge_counts = tiles.values.map(&.edges).flatten.tally
# puts edge_counts

# puts tiles[2477].edges

# a = %w(ab cd)
# puts rot(a, 1).join("\n")
# puts rot(a, 2).join("\n")
# puts rot(a, 3).join("\n")

# ab -> ca -> dc -> bd
# cd    db    ba    ac

# puts flip_x(a).join("\n")
# puts rot(flip_x(a), 1).join("\n")
# puts rot(flip_x(a), 2).join("\n")
# puts rot(flip_x(a), 3).join("\n")

# ba -> db -> cd -> ac
# dc    ca    ab    bd

def solve(pos_stack, tiles, visited = Set(Int32).new, soln = {} of Tuple(Int32, Int32) => Tuple(Int32, Int32))
  if pos_stack.empty?
    return soln
  end

  x, y = pos_stack.shift
  tiles.each do |id, variations|
    next if visited.includes? id
    visited.add id
    variations.each_with_index do |variation, idx|
      left_soln = soln[{x - 1, y}]?
      up_soln = soln[{x, y - 1}]?
      next if left_soln && right(tiles[left_soln[0]][left_soln[1]]) != left(variation)
      next if up_soln && bot(tiles[up_soln[0]][up_soln[1]]) != top(variation)
      soln[{x, y}] = {id, idx}
      if ans = solve(pos_stack, tiles, visited, soln)
        return ans
      end
      soln.delete({x, y})
    end
    visited.delete id
  end
  pos_stack.unshift({x, y})
  nil
end

def stitch(soln, tiles)
  trimmed = soln.transform_values do |id, variation_idx|
    trim_border tiles[id][variation_idx]
  end
  dim = Math.sqrt(trimmed.size).to_i32

  grid = (0...dim).map { |y| (0...dim).map { |x| trimmed[{x,y}] } }
  grid.map do |row|
    (0...row.first.size).map do |y|
      row.map(&.[y]).join
    end
  end.reduce([] of String) do |curr, acc|
    curr.concat(acc)
  end
end

def trim_border(tile)
  tile[1..-2].map { |r| r[1..-2] }
end

def monster_at(img, pos)
  ptn = [
    "                  # ",
    "#    ##    ##    ###",
    " #  #  #  #  #  #   ",
  ]
  ptn.each_with_index do |row, y|
    row.each_char_with_index do |c, x|
      img_row = img[pos[1] + y]?
      img_col = img_row ? img_row[pos[0] + x]? : nil
      return false if c == '#' && img_col != '#'
    end
  end
  true
end

def draw_monster_at(img, pos)
  ptn = [
    "                  # ",
    "#    ##    ##    ###",
    " #  #  #  #  #  #   ",
  ]
  ptn.each_with_index do |row, y|
    row.each_char_with_index do |c, x|
      next unless c == '#'
      img[pos[1] + y] = img[pos[1] + y].sub(pos[0] + x, 'O')
    end
  end
  img
end

tiles = {} of Int32 => Array(String)
File.read("./day_20.txt").split("\n\n").map(&.lines).reject(&.empty?).each do |lines|
  title = lines[0]
  tiles[title.match(/\d+/).not_nil![0].to_i] = lines[1..]
end
tile_variations = tiles.transform_values { |v| variations(v) }

dim = Math.sqrt(tile_variations.size).to_i32
pos_stack = (0...dim).map { |y| (0...dim).map { |x| {x, y} } }.flatten

soln = solve(pos_stack, tile_variations).not_nil!
corners = [
  soln[{0, 0}][0].to_u64,
  soln[{0, dim - 1}][0].to_u64,
  soln[{dim - 1, 0}][0].to_u64,
  soln[{dim - 1, dim - 1}][0].to_u64,
]
puts "part 1: #{corners.product}"

final_img = stitch(soln, tile_variations)
puts final_img
final_variations = variations(final_img)
final_variations.each_with_index do |variation, index|
  has_monster = false
  dim = variation.size
  (0...dim).each do |y|
    (0...dim).each do |x|
      if monster_at(variation, {x,y})
        variation = draw_monster_at(variation, {x,y})
        has_monster = true
      end
    end
  end
  if has_monster
    puts "variation #{index} has monster"
    puts "part 2: #{variation.join.chars.select('#').size}"
  end
end
