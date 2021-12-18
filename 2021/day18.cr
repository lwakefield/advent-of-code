# Sat Dec 18 13:09:15 EST 2021

def get_explodes(tokens)
  count = 0
  (0...tokens.size).each do |i|
    if tokens[i] == '['
      if count == 4
        return i
      else
        count += 1
      end
    elsif tokens[i] == ']'
      count -= 1
    end
  end
  return -1
end

def get_splits(tokens)
  (0...tokens.size).each do |i|
    if tokens[i].is_a?(Int32) && tokens[i].as(Int32) >= 10
      return i
    end
  end
  return -1
end

def reduce (tokens)
  # puts tokens.join
  loop do
    explode_at = get_explodes(tokens)
    if explode_at != -1
      # puts "exploding at #{explode_at}"
      tokens = explode tokens, explode_at
      # puts tokens.join
      next
    end

    split_at = get_splits(tokens)
    if split_at != -1
      # puts "splitting at #{split_at}"
      tokens = split tokens, split_at
      # puts tokens.join
      next
    end

    return tokens
  end
end

def explode (tokens, index) # index is a [
  raise "expected [ at #{index}"     unless tokens[index] == '['
  raise "expected Int at #{index+1}" unless tokens[index  +  1].is_a?(Int32)
  raise "expected , at #{index+2}"   unless tokens[index  +  2] == ','
  raise "expected Int at #{index+3}" unless tokens[index  +  3].is_a?(Int32)
  raise "expected ] at #{index+4}"   unless tokens[index  +  4] == ']'

  left_index = index - 1
  until left_index < 0 || tokens[left_index].is_a?(Int32)
    left_index -= 1
  end

  right_index = index + 5
  until right_index >= tokens.size || tokens[right_index].is_a?(Int32)
    right_index += 1
  end

  if left_index != -1
    tokens[left_index] = tokens[left_index].as(Int32) + tokens[index+1].as(Int32)
  end

  if right_index != tokens.size
    tokens[right_index] = tokens[right_index].as(Int32) + tokens[index+3].as(Int32)
  end

  tokens[index..index+4] = 0

  tokens
end

def split (tokens, index)
  # To split a regular number, replace it with a pair; the left element of the
  # pair should be the regular number divided by two and rounded down, while
  # the right element of the pair should be the regular number divided by two
  # and rounded up. For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes
  # [6,6], and so on.
  n = tokens[index].as(Int32)
  left = (n.to_f32 / 2).floor.to_i32
  right = (n.to_f32 / 2).ceil.to_i32

  tokens[index..index] = ['[', left, ',', right, ']']
  tokens
end

def add (left, right)
  ['['] + left + [','] + right + [']']
end

def sum (numbers)
  sum = numbers.first
  # puts sum.join
  numbers[1..].each do |n|
    sum = reduce(add(sum, n))
    # puts sum.join
  end
  sum
end

def magnitude (tokens, index=0)
  # To check whether it's the right answer, the snailfish teacher only checks
  # the magnitude of the final sum. The magnitude of a pair is 3 times the
  # magnitude of its left element plus 2 times the magnitude of its right
  # element. The magnitude of a regular number is just that number.
  stack = tokens
  acc = [] of Int32
  left = nil
  right = nil
  depth = 0
  until stack.empty?
    t = tokens.shift
    if t == '['
    elsif t == ']'
      acc << 2 * acc.pop + 3 * acc.pop
    elsif t.is_a?(Int32)
      acc << t.as(Int32)
    elsif t == ','
    else
      raise "unxpected token #{t}"
    end
  end

  acc.first
end

def parse2(str)
  str.chars.map do |c|
    if c.ascii_number?
      c.to_i
    else
      c
    end
  end
end

# puts explode(parse2("[[[[[9,8],1],2],3],4]"), 4).join
# puts explode(parse2("[7,[6,[5,[4,[3,2]]]]]"), 12).join
# puts explode(parse2("[[6,[5,[4,[3,2]]]],1]"), 10).join
# puts explode(parse2("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] "), 10).join
# puts explode(parse2("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"), 24).join

# puts split(['[', 10, ',', 0, ']'], 1)
# puts split(['[', 11, ',', 0, ']'], 1)
# puts split(['[', 12, ',', 0, ']'], 1)

# puts reduce(parse2("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"))



numbers = [] of Array(Char|Int32)
STDIN.each_line do |line|
 numbers << parse2(line)
end

puts magnitude(sum(numbers))

# solved part 1: Sat Dec 18 15:45:01 EST 2021

# puts reduce(add(
#   parse2("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]"),
#   parse2("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
# )).join

# [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]] + [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
# [[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]
# [[[[4,0],[5,0]],[[[4,5],[2,6]],[9,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]
# [[[[4,0],[5,4]],[[0,[7,6]],[9,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]

puts "part 2: #{numbers.permutations(2).map do |pair|
  magnitude(sum(pair))
end.max}"

# Sat Dec 18 15:47:14 EST 2021
