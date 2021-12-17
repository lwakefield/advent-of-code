require "big"

# Tue Dec 14 05:59:16 EST 2021

template_start, pairs = STDIN.gets_to_end.split("\n\n")

insertion_rules = {} of String => String
pairs.lines.each do |line|
  left, right = line.split(" -> ")
  insertion_rules[left] = left[0] + right + left[1]
end

def tick(template, insertion_rules)
  res = insertion_rules[template[0..1]]
  template.chars[1..].each_cons(2) do |pair|
    res = res.delete_at(-1)
    res += insertion_rules[pair.join]
  end
  res
end



template = template_start.dup
10.times { template = tick(template, insertion_rules) }
tally = template.chars.tally
puts "part 1: #{tally.values.max - tally.values.min}"

# Tue Dec 14 06:13:36 EST 2021
# 6:30

def mutate (str, insertion_rules, num_mutations)
  pairs = (0...str.size-1).map do |i|
    str[i..i+1]
  end.tally

  num_mutations.times do
    next_pairs = {} of String => UInt64
    pairs.each do |k, v|
      left = insertion_rules[k][0..1]
      right = insertion_rules[k][1..2]
      next_pairs[left] ||= 0
      next_pairs[left] += v
      next_pairs[right] ||= 0
      next_pairs[right] += v
    end
    pairs = next_pairs
  end
  pairs
end

res = mutate template_start, insertion_rules, 40
counts = {} of Char => UInt64
res.each do |k, v|
  k.chars.each do |c|
    counts[c] ||= 0
    counts[c] += v
  end
end
counts[template_start.chars.first] += 1
counts[template_start.chars.last]  += 1
counts.each_key do |k|
  counts[k] = counts[k] // 2
end
puts "part 2: #{counts.values.max - counts.values.min}"


# Fri Dec 17 07:56:59 EST 2021
# Fri Dec 17 08:18:16 EST 2021
