map = File.read(ARGV.first).lines.map(&.split).map do |p|
  {p[0], p[1].split(',').map(&.to_i)}
end

alias SCache = Hash(Tuple(String, Array(Int32)), Array(String))
def possibilities3 (group : String, check : Array(Int32), cache=SCache.new) : Array(String)
  if r=cache[{group, check}]?
    return r
  end
  i = group.index(/\?|#/)

  cset = ->(v : Array(String)) {
    cache[{group, check}] = v
    v
  }

  return cset.call([group]) if i.nil? && check.empty?
  return cset.call([] of String) if i.nil? && !check.empty?

  raise "err" if i.nil?

  r = [] of String

  if !check.empty? && group[i..] =~ /^[#\?]{#{check.first}}[\?\.]/
    r += possibilities3(group[i+$~.end..], check[1..], cache).map{|r| group[...i] + "#" * check.first + "." + r}
  end

  if check.size == 1  && group[i..] =~ /^[#\?]{#{check.first}}$/
    return cset.call([ group[...i] + "#" * check.first ])
  end

  if group[i] == '?'
    r += possibilities3(group[i+1..], check, cache).map{|r| group[...i] + "." + r}
  end

  cset.call(r)
end

puts "Part 1: #{map.map{|m| possibilities3(*m).size}.sum}"


alias ICache = Hash(Tuple(String, Array(Int32)), UInt64)
def possibilities4 (group : String, check : Array(Int32), cache=ICache.new) : UInt64
  if r=cache[{group, check}]?
    return r
  end
  i = group.index(/\?|#/)

  cset = ->(v : UInt64) {
    cache[{group, check}] = v
    v
  }

  return cset.call(1_u64) if i.nil? && check.empty?
  return cset.call(0_u64) if i.nil? && !check.empty?

  raise "err" if i.nil?

  r = 0_u64

  if !check.empty? && group[i..] =~ /^[#\?]{#{check.first}}[\?\.]/
    r += possibilities4(group[i+$~.end..], check[1..], cache)
  end

  if check.size == 1  && group[i..] =~ /^[#\?]{#{check.first}}$/
    return cset.call(1_u64)
  end

  if group[i] == '?'
    r += possibilities4(group[i+1..], check, cache)
  end

  cset.call(r)
end

map = map.dup.map do |p|
  { ([p[0]] * 5).flatten.join("?"), p[1] * 5 }
end
puts "Part 2: #{map.map_with_index{|m,i| puts i; possibilities4(*m); }.sum}"
