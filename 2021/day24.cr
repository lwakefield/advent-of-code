def block(w, z, pop, a, b)
  x, y = 0, 0
  x = (z % 26) + a
  z = z.tdiv (pop ? 26 : 1)
  if x != w
    z *= 26
    z += w + b
  end

  z
end

blocks = [
  { false, 13,  6 },
  { false, 11,  11 },
  { false, 12,  5 },
  { false, 10,  6 },
  { false, 14,  8 },
  { true, -1,  14 },
  { false, 14,  9 },
  { true, -16,  4 },
  { true, -8,  7 },
  { false, 12,  13 },
  { true,  -16, 11 },
  { true,  -13, 11 },
  { true,  -6,  6 },
  { true,  -6,  -1 }
]

def solve (blocks)
  solns = [] of Tuple(Int64, Int32)
  (1i64..9i64).each do |w|
    solns << { w, block(w, 0, *blocks[0]) }
  end

  (1..13).each do |i|
    next_solns = [] of Tuple(Int64, Int32)
    solns.each do |input, z|
      (1i64..9i64).each do |w|
        soln = { input * 10 + w, block(w, z, *blocks[i]) }
        if blocks[i][0]
          if soln[1] == z.tdiv 26
            next_solns << { input * 10 + w, block(w, z, *blocks[i]) }
          end
        else
          next_solns << { input * 10 + w, block(w, z, *blocks[i]) }
        end
      end
    end
    solns = next_solns
  end

  solns
end

puts solve(blocks).map(&.[0]).max
puts solve(blocks).map(&.[0]).min
