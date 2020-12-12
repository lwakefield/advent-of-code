DIRS = {
  'N' => {0, +1},
  'E' => {+1, 0},
  'S' => {0, -1},
  'W' => {-1, 0},
}

def add(v1, v2)
  {v1[0] + v2[0], v1[1] + v2[1]}
end

def mul(v1, m)
  {v1[0] * m, v1[1] * m}
end

def rot(v, deg)
  case deg
    when -270  then { +v[1], -v[0]  }
    when -180  then { -v[0], -v[1] }
    when -90   then { -v[1], +v[0] }

    when 90    then { +v[1], -v[0] }
    when 180   then { -v[0], -v[1] }
    when 270   then { -v[1], +v[0]  }
    else raise "err"
  end
end

def part1(instructions)
  pos = {0, 0}
  dir = {1, 0}
  instructions.each do |inst|
    op, arg = inst[0], inst[1..].to_i
    case op
    when 'N', 'S', 'E', 'W' then pos = add(pos, mul(DIRS[op], arg))
    when 'L'                then dir = rot(dir, -arg)
    when 'R'                then dir = rot(dir, arg)
    when 'F'                then pos = add(pos, mul(dir, arg))
    end
  end
  {pos, dir}
end

def part2(instructions)
  pos = {0, 0}
  dir = {10, 1}
  instructions.each do |inst|
    op, arg = inst[0], inst[1..].to_i
    case op
    when 'N', 'S', 'E', 'W' then dir = add(dir, mul(DIRS[op], arg))
    when 'L'                then dir = rot(dir, -arg)
    when 'R'                then dir = rot(dir, arg)
    when 'F'                then pos = add(pos, mul(dir, arg))
    end
  end
  {pos, dir}
end

instructions = File.read_lines("./day_12.txt")

pos, dir = part1(instructions)
puts "part 1 pos: #{pos} dir: #{dir} dist: #{pos[0].abs + pos[1].abs}"

pos, dir = part2(instructions)
puts "part 2 pos: #{pos} dir: #{dir} dist: #{pos[0].abs + pos[1].abs}"
