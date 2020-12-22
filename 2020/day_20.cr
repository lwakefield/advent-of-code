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

def top_edge(cells)
  cells.first
end

def right_edge(cells)
  cells.map(&.char_at(-1)).join
end

def bot_edge(cells)
  cells.last
end

def left_edge(cells)
  cells.map(&.char_at(0)).join
end

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
      next if left_soln && right_edge(tiles[left_soln[0]][left_soln[1]]) != left_edge(variation)
      next if up_soln && bot_edge(tiles[up_soln[0]][up_soln[1]]) != top_edge(variation)
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
