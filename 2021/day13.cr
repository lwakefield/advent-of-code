# Mon Dec 13 07:00:13 EST 2021

dots, folds = STDIN.gets_to_end.split("\n\n")

dots = dots.lines.map do |line|
  x, y = line.split(",").map(&.to_i32)
  { x, y }
end
width = dots.map(&.[0]).max + 1
height = dots.map(&.[1]).max + 1

paper_start = [] of Array(Char)
height.times do
  paper_start << ['.'] * width
end

dots.each do |x, y|
  paper_start[y][x] = '#'
end

def xbisect(paper, x)
  width = paper.first.size
  left, right = [] of Array(Char), [] of Array(Char)

  (0...paper.size).each do |y|
    left << paper[y][0...x]
    right << paper[y][x+1..]
  end

  { left, right }
end

def ybisect(paper, y)
  top = paper.dup[0...y]
  bottom = paper.dup[y+1..]

  { top, bottom }
end

# ab -> ba
# cd    dc
def xmirror(paper)
  paper.map do |row|
    row.reverse
  end
end

def ymirror(paper)
  paper.reverse
end

def fold (paper, instruction)
  case instruction
  when /fold along x=(\d+)/
    x = $~.not_nil![1].to_i32

    left, right = xbisect(paper, x)
    left, right = right, left if right.first.size > left.first.size
    right = xmirror(right)

    new_paper = left
    x_offset = left.first.size - right.first.size
    right.each_with_index do |row, y|
      row.each_with_index do |v, x|
        new_paper[y][x_offset + x] = v if v == '#'
      end
    end

    return new_paper
  when /fold along y=(\d+)/
    y = $~.not_nil![1].to_i32

    top, bottom = ybisect(paper, y)
    top, bottom = bottom, top if bottom.size > top.size
    bottom = ymirror(bottom)

    new_paper = top
    y_offset = top.size - bottom.size
    bottom.each_with_index do |row, y|
      row.each_with_index do |v, x|
        new_paper[y_offset + y][x] = v if v == '#'
      end
    end

    return new_paper
  end
  raise "err"
end

paper = paper_start.dup
paper = fold(paper, folds.lines.first)
puts "part 1: #{paper.flatten.tally['#']}"

# pausing here - 297 was too low...
# Mon Dec 13 07:35:56 EST 2021

# Mon Dec 13 16:44:08 EST 2021
# Mon Dec 13 17:02:17 EST 2021

# Mon Dec 13 18:13:31 EST 2021

paper = paper_start.dup
folds.lines.each do |inst|
  paper = fold(paper, inst)
end
puts paper.map(&.join).join("\n")

# Mon Dec 13 18:14:39 EST 2021
