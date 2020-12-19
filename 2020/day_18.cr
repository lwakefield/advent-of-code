require "string_scanner"

def lex(str)
  rgx = Regex.union([
    /\d+/,
    /\s+/,
    /\*/,
    /\+/,
    /\(/,
    /\)/,
  ])

  s = StringScanner.new(str)
  tokens = [] of String
  while t = s.scan(rgx)
    tokens << t unless t.strip.empty?
  end
  raise "err" unless s.eos?
  tokens
end

class Node
  getter val
  getter children = [] of Node

  def initialize(@val : String)
  end
end

def get_precedence(tok)
  case tok
  when "*" then 1
  when "+" then 2
  when "(" then 3
  else          0
  end
end

def parse_infix(left, tokens)
    return nil unless tokens[0] == "+" || tokens[0] == "*"

    n = Node.new(tokens[0])
    n.children << left
    precedence = get_precedence(tokens[0])
    tokens.shift
    n.children << parse_expression(precedence, tokens)
    n
end

def parse_prefix(tokens)
    case tokens[0]
    when .matches? /\d+/ then Node.new(tokens.shift)
    when "("
        tokens.shift
        n = Node.new("()")
        n.children << parse_expression(0, tokens)
        raise "expected )" unless tokens[0] == ")"
        tokens.shift
        n
    else raise "could not parse #{tokens[0]}"
    end
end

def parse_expression (precedence, tokens)
  left = parse_prefix(tokens)
  raise "no prefix expr" unless left

  while !tokens.empty? && precedence < get_precedence(tokens[0])
    infix = parse_infix(left, tokens)
    return left if infix.nil?
    left = infix
  end
  left
end

def eval (node)
    if node.val == "()"
        return eval node.children.first
    elsif node.val == "+"
        return eval(node.children[0]) + eval(node.children[1])
    elsif node.val == "*"
        return eval(node.children[0]) * eval(node.children[1])
    elsif node.val =~ /\d+/
        return node.val.to_u64
    else raise "could not eval #{node}"
    end
end

def run (str)
    eval(parse_expression(0, lex(str)))
end

acc = 0u64
File.each_line("day_18.txt") do |line|
  begin
    acc += run(line)
  rescue ex
    puts ex
    puts line
  end
end
puts "part 2: #{acc}"
