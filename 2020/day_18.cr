require "string_scanner"

class Node
  property val : String
  property children = [] of Node

  def initialize(@val)
  end
end

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

def eval(str)
  eval_tokens(lex(str))
end

def eval_tokens(tokens)
  res_stack = [] of UInt64
  op_stack = [] of String

  until tokens.empty?
    tok = tokens.shift
    # puts "tok=#{tok} res=#{res_stack} op=#{op_stack}"

    case tok
    when "+", "*" then op_stack << tok
    when .matches? /\d+/
      case op_stack.pop?
      when "+" then res_stack[-1] += tok.to_u64
      when "*" then res_stack[-1] *= tok.to_u64
      else res_stack << tok.to_u64
      end
    when "(" then op_stack << "("
    when ")"
      val = res_stack.pop?
      case op_stack.pop?
      when "+" then res_stack[-1] += val.not_nil!
      when "*" then res_stack[-1] *= val.not_nil!
      else
        res_stack << val if val
      end
    else
      raise "unhandled token #{tok}"
    end
  end

  raise "unfinished expression res=#{res_stack} op=#{op_stack}" unless res_stack.size == 1
  res_stack[0]
end

def eval_tokens_2(tokens)
end

acc = 0u64
File.each_line("day_18.txt") do |line|
begin
    acc += eval(line)
    rescue ex
        puts ex
        puts line
        end
end
puts "part 1: #{acc}"
