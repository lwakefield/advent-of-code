# Sat Dec  4 08:30:57 EST 2021

input = STDIN.gets_to_end

input = input.split("\n\n")
numbers, boards = input.first, input[1..]
numbers = numbers.split(",").map(&.to_i32)

boards = boards.map do |board|
  board.lines.map(&.split.map(&.to_i32))
end

def board_wins? (board, numbers)
  return true if board[0].to_set.subset_of? numbers.to_set
  return true if board[1].to_set.subset_of? numbers.to_set
  return true if board[2].to_set.subset_of? numbers.to_set
  return true if board[3].to_set.subset_of? numbers.to_set
  return true if board[4].to_set.subset_of? numbers.to_set
  return true if board.map(&.[0]).to_set.subset_of? numbers.to_set
  return true if board.map(&.[1]).to_set.subset_of? numbers.to_set
  return true if board.map(&.[2]).to_set.subset_of? numbers.to_set
  return true if board.map(&.[3]).to_set.subset_of? numbers.to_set
  return true if board.map(&.[4]).to_set.subset_of? numbers.to_set
  false
end

puts board_wins?(
  [[0, 1, 2, 3, 4],
  [5, 6, 7, 8, 9],
  [10, 11, 12, 13, 14],
  [15, 16, 17, 18, 19],
  [20, 21, 22, 23, 24]],
  [0, 1, 2, 3, 4]
)
puts board_wins?(
  [[0, 1, 2, 3, 4],
  [5, 6, 7, 8, 9],
  [10, 11, 12, 13, 14],
  [15, 16, 17, 18, 19],
  [20, 21, 22, 23, 24]],
  [20, 21, 22, 23, 24],
)
puts board_wins?(
  [[0, 1, 2, 3, 4],
  [5, 6, 7, 8, 9],
  [10, 11, 12, 13, 14],
  [15, 16, 17, 18, 19],
  [20, 21, 22, 23, 24]],
  [0, 5, 10, 15, 20]
)
puts board_wins?(
  [[0, 1, 2, 3, 4],
  [5, 6, 7, 8, 9],
  [10, 11, 12, 13, 14],
  [15, 16, 17, 18, 19],
  [20, 21, 22, 23, 24]],
  [4, 9, 14, 19, 24]
)
puts board_wins?(
  [[0, 1, 2, 3, 4],
  [5, 6, 7, 8, 9],
  [10, 11, 12, 13, 14],
  [15, 16, 17, 18, 19],
  [20, 21, 22, 23, 24]],
  [4, 2, 3, 1, 1, 1, 1, 4, 0]
)

(1..numbers.size).each do |count|
  winner = boards.find do |board|
    board_wins? board, numbers[0...count]
  end
  if winner
    unmarked = winner.flatten.reject { |n| numbers[0...count].includes? n }
    puts "part 1: #{unmarked.sum * numbers[count-1]}"
    break
  end
end

# Sat Dec  4 08:46:39 EST 2021

(1..numbers.size).each do |count|
  boards.select do |board|
    board_wins? board, numbers[0...count]
  end.each do |winner|
    boards.delete winner
    unmarked = winner.flatten.reject { |n| numbers[0...count].includes? n }
    puts "part 2: #{unmarked.sum * numbers[count-1]}"
  end
end

# Sat Dec  4 09:00:05 EST 2021
