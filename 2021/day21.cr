def play(p1, p2)
  pos    = [p1, p2]
  scores = [0, 0]
  roll = (1..100).cycle
  rounds = 0
  [0, 1].cycle do |i|
    round = tick2(i, pos, scores, (roll.next.as(Int32) + roll.next.as(Int32) + roll.next.as(Int32)))
    pos, scores = round[:pos], round[:scores]
    rounds += 3

    return { pos: pos, scores: scores, rounds: rounds } if scores[i] >= 1000
  end
end

result = play(2, 7)
puts "part 1: #{ result[:scores].min * result[:rounds] }"

def tick2(turn, pos, scores, roll)
  pos, scores = pos.dup, scores.dup
  i = turn % 2
  pos[i] += roll
  pos[i] = 1 + (pos[i]-1) % 10
  scores[i] += pos[i]
  { pos: pos, scores: scores }
end

def play3(turn, pos, scores)
  wins = [0u64, 0u64]

  [
    {1u64, tick2(turn, pos, scores, 3).merge(turn: turn + 1)},
    {3u64, tick2(turn, pos, scores, 4).merge(turn: turn + 1)},
    {6u64, tick2(turn, pos, scores, 5).merge(turn: turn + 1)},
    {7u64, tick2(turn, pos, scores, 6).merge(turn: turn + 1)},
    {6u64, tick2(turn, pos, scores, 7).merge(turn: turn + 1)},
    {3u64, tick2(turn, pos, scores, 8).merge(turn: turn + 1)},
    {1u64, tick2(turn, pos, scores, 9).merge(turn: turn + 1)},
  ].each do |count, game|
    if game[:scores][turn % 2] >= 21
      wins[turn % 2] += count
    else
      w = play3(game[:turn], game[:pos], game[:scores])
      wins[0] += count * w[0]
      wins[1] += count * w[1]
    end
  end

  wins
end

result = play3(0u64, pos: [2, 7], scores: [0, 0])
puts "part 2: #{ result.max }"
