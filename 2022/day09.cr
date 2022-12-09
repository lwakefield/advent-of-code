instructions = STDIN.gets_to_end.lines

head_pos = {0, 0}
tail_pos_history = [{0,0}] of Tuple(Int32,Int32)

def add(a,b)
  {a[0]+b[0], a[1]+b[1]}
end
def sub(a,b)
  {a[0]-b[0], a[1]-b[1]}
end

instructions.each do |inst|
  dir, amt = inst.split " "
  amt = amt.to_i32

  amt.times do
    case dir
    when "R" then head_pos = add(head_pos,{1,0})
    when "L" then head_pos = add(head_pos,{-1,0})
    when "U" then head_pos = add(head_pos,{0,1})
    when "D" then head_pos = add(head_pos,{0,-1})
    end

    tail_pos = tail_pos_history.last

    is_stretched = !(
      (head_pos[0]-1..head_pos[0]+1).includes?(tail_pos[0]) &&
      (head_pos[1]-1..head_pos[1]+1).includes?(tail_pos[1])
    )

    next unless is_stretched

    d = sub(head_pos,tail_pos)
    d = {d[0].clamp(-1,1), d[1].clamp(-1,1)}
    tail_pos_history << add(tail_pos, d)
  end
end

puts "part 1: #{tail_pos_history.to_set.size}"

knots_history = [ [{0,0}] * 10 ]

instructions.each do |inst|
  dir, amt = inst.split " "
  amt = amt.to_i32

  amt.times do
    knots = knots_history.last
    head_pos = knots.first
    case dir
    when "R" then head_pos = add(head_pos,{1,0})
    when "L" then head_pos = add(head_pos,{-1,0})
    when "U" then head_pos = add(head_pos,{0,1})
    when "D" then head_pos = add(head_pos,{0,-1})
    end

    next_knots = [ head_pos ]

    knots[1..].each do |k|
      last_knot = next_knots.last

      is_stretched = !(
        (last_knot[0]-1..last_knot[0]+1).includes?(k[0]) &&
        (last_knot[1]-1..last_knot[1]+1).includes?(k[1])
      )

      if is_stretched
        d = sub(last_knot,k)
        d = {d[0].clamp(-1,1), d[1].clamp(-1,1)}
        next_knots << add(k, d)
      else
        next_knots << k
      end
    end

    knots_history << next_knots
  end
end

puts "part 2: #{knots_history.map(&.last).to_set.size}"
