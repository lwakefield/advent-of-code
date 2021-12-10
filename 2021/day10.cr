# Fri Dec 10 06:05:38 EST 2021

chunks = ARGF.read.lines

def check (chunk)
  stack = []
  chunk.chars.each do |c|
    case c
    when '(' then stack << c
    when '[' then stack << c
    when '<' then stack << c
    when '{' then stack << c
    when ')'
      if stack.last == '('
        stack.pop
      else
        return { expected: ')', found: c }
      end
    when ']' then
      if stack.last == '['
        stack.pop
      else
        return { expected: ']', found: c }
      end
    when '>' then
      if stack.last == '<'
        stack.pop
      else
        return { expected: '>', found: c }
      end
    when '}' then
      if stack.last == '{'
        stack.pop
      else
        return { expected: '}', found: c }
      end
    end
  end

  unless stack.empty?
    return { msg: "incomplete" }
  end
end

errors = chunks.map{|c| check(c)}
error_codes = {')'=>3, ']'=>57, '}'=>1197, '>'=>25137 }

puts "part 1: #{errors.compact
  .select{|e| e.has_key?(:expected)}
  .map{|e| error_codes[e[:found]] }
  .sum}"

# Fri Dec 10 06:27:49 EST 2021

def autocomplete (chunk)
  stack = []
  chunk.chars.each do |c|
    case c
    when '(' then stack << c
    when '[' then stack << c
    when '<' then stack << c
    when '{' then stack << c
    when ')' then stack.pop
    when ']' then stack.pop
    when '>' then stack.pop
    when '}' then stack.pop
    end
  end

  stack.reverse.map do |c|
    case c
    when '(' then ')'
    when '[' then ']'
    when '<' then '>'
    when '{' then '}'
    end
  end
end

incomplete = chunks.select do |chunk|
  check(chunk).has_key? :msg
end

autocomplete_scores = incomplete.map do |chunk|
  autocomplete(chunk).map do |c|
    {
      ')' => 1,
      ']' => 2,
      '}' => 3,
      '>' => 4,
    }[c]
  end.reduce(0) do |memo, c|
    memo *= 5
    memo += c
  end
end.sort
puts "part 2: #{autocomplete_scores[autocomplete_scores.size / 2]}"

# Fri Dec 10 06:37:02 EST 2021
