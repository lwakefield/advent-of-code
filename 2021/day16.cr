# Fri Dec 17 15:25:07 EST 2021
CONVERSION_TABLE = {
  '0' => "0000",
  '1' => "0001",
  '2' => "0010",
  '3' => "0011",
  '4' => "0100",
  '5' => "0101",
  '6' => "0110",
  '7' => "0111",
  '8' => "1000",
  '9' => "1001",
  'A' => "1010",
  'B' => "1011",
  'C' => "1100",
  'D' => "1101",
  'E' => "1110",
  'F' => "1111",
}

def hex_to_bin(hex)
  hex.chars.map do |c|
    CONVERSION_TABLE[c]
  end.flatten.join
end

bits = hex_to_bin STDIN.gets.not_nil!

class Scanner
  @pointer = 0
  def initialize(@val : String)
  end
  def read(n)
    read_raw(n).to_i64(2)
  end
  def read_raw(n)
    # pp @pointer, n, @val.size
    v = @val[@pointer...@pointer+n]
    @pointer += n
    v
  end
  def peek_at_offset(i, n)
    peek_raw_at_offset(i, n).to_i64(2)
  end
  def peek_raw_at_offset(i, n)
    @val[@pointer+i...@pointer+i+n]
  end
  def eos?
    @pointer >= @val.size
  end
  def remaining
    @val.size - @pointer
  end
end

class Operator
  getter version
  getter type
  getter length_mode
  getter length
  property children = [] of Operator|LiteralValue
  def initialize(@version : Int64, @type : Int64, @length_mode : Int64, @length : Int64)
  end
end
class LiteralValue
  getter version
  getter type
  getter value
  def initialize(@version : Int64, @type : Int64, @value : Int64)
  end
end

def parse_literal_value(scanner)
  version = scanner.read(3)
  type    = scanner.read(3)
  res = ""
  loop do
    part = scanner.read_raw(5)
    res += part[1..]
    break if part[0] == '0'
  end
  LiteralValue.new(version, type, res.to_i64(2))
end

def parse_operator(scanner)
  version = scanner.read(3)
  type    = scanner.read(3)
  length_mode = scanner.read(1)
  if length_mode == 0
    length = scanner.read(15)
    operator = Operator.new(version, type, length_mode, length)
    subpackets = scanner.read_raw(length)
    operator.children += parse_bits(Scanner.new(subpackets))
    return operator
  else
    length = scanner.read(11)
    operator = Operator.new(version, type, length_mode, length)
    operator.children += parse_bits(scanner, length)
    return operator
  end
end

def parse_bits (scanner, limit_packets=UInt32::MAX)
  packets = [] of LiteralValue|Operator

  until scanner.eos? || packets.size >= limit_packets || scanner.remaining < 6
    if scanner.peek_at_offset(3, 3) == 4
      packets << parse_literal_value(scanner)
    else
      packets << parse_operator(scanner)
    end
  end

  packets
end
# Fri Dec 17 15:56:21 EST 2021
# Fri Dec 17 16:24:05 EST 2021
# Fri Dec 17 17:12:07 EST 2021
# Fri Dec 17 17:25:52 EST 2021
# Fri Dec 17 17:27:41 EST 2021
# Fri Dec 17 17:28:35 EST 2021
# solved p1: Fri Dec 17 17:35:56 EST 2021
# Fri Dec 17 17:39:34 EST 2021
# Sat Dec 18 07:32:22 EST 2021
# solved p2: Sat Dec 18 07:39:34 EST 2021

def count_versions(packets)
  count = 0
  packets.each do |p|
    count += p.version
    count += count_versions(p.children) if p.is_a?(Operator)
  end
  count
end

def eval(packet) : Int64
  if packet.is_a? LiteralValue
    return packet.value
  elsif packet.is_a? Operator && packet.type == 0
    packet.children.map do |p|
      eval(p)
    end.sum
  elsif packet.is_a? Operator && packet.type == 1
    packet.children.reduce(1i64) do |acc, p|
      acc *= eval(p)
    end
  elsif packet.is_a? Operator && packet.type == 2
    packet.children.map do |p|
      eval(p)
    end.min
  elsif packet.is_a? Operator && packet.type == 3
    packet.children.map do |p|
      eval(p)
    end.max
  elsif packet.is_a? Operator && packet.type == 5
    eval(packet.children[0]) > eval(packet.children[1]) ? 1i64 : 0i64
  elsif packet.is_a? Operator && packet.type == 6
    eval(packet.children[0]) < eval(packet.children[1]) ? 1i64 : 0i64
  elsif packet.is_a? Operator && packet.type == 7
    eval(packet.children[0]) == eval(packet.children[1]) ? 1i64 : 0i64
  else
    raise "ahhh"
  end
end

# scanner = Scanner.new(bits)
# pp parse_bits(scanner)

# pp parse_bits(Scanner.new("110100101111111000101000"))
# pp parse_bits(Scanner.new("00111000000000000110111101000101001010010001001000000000"), 1)
# pp parse_bits(Scanner.new("11101110000000001101010000001100100000100011000001100000"), 1)
# pp count_versions(parse_bits Scanner.new(hex_to_bin "8A004A801A8002F478"))
# pp count_versions(parse_bits Scanner.new(hex_to_bin "620080001611562C8802118E34"))
# pp count_versions(parse_bits Scanner.new(hex_to_bin "C0015000016115A2E0802F182340"), 1)
# pp count_versions(parse_bits Scanner.new(hex_to_bin "A0016C880162017C3686B18A3D4780"), 1)
pp count_versions(parse_bits Scanner.new(bits), 1)

pp eval(parse_bits(Scanner.new(bits), 1)[0])
