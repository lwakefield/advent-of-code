map = File.read ARGV.first

def beam_me_up(b, map)
  w = map.index('\n').not_nil!
  visited = Set(Tuple(Int32, Symbol)).new
  beams = [b]
  until beams.empty?
    beam = beams.pop
    next if visited.includes? beam
    visited << beam

    pos, dir = beam
    pos = case dir
          when :left  then pos - 1
          when :right then pos + 1
          when :down  then pos + (w + 1)
          when :up    then pos - (w + 1)
          else             raise "err"
          end
    next unless (0...map.size).includes? pos
    next if map[pos] == '\n'

    case map[pos]
    when '.'
      beams << {pos, dir}
    when '/'
      dir = {:right => :up, :down => :left, :left => :down, :up => :right}[dir]
      beams << {pos, dir}
    when '\\'
      dir = {:right => :down, :down => :right, :left => :up, :up => :left}[dir]
      beams << {pos, dir}
    when '-'
      if [:up, :down].includes? dir
        beams << {pos, :left}
        beams << {pos, :right}
      else
        beams << {pos, dir}
      end
    when '|'
      if [:left, :right].includes? dir
        beams << {pos, :up}
        beams << {pos, :down}
      else
        beams << {pos, dir}
      end
    else raise "err"
    end
  end

  visited
end

puts "Part 1: #{beam_me_up({-1, :right}, map).map(&.[0]).uniq.size - 1}"

w = map.index('\n').not_nil!
h = map.size // (w + 1)
b = (0...h).map { |y| {-1 + y * (w + 1), :right} } +
    (1..h).map { |y| {-1 + y * (w + 1), :left} } +
    (0..w).map { |x| {x-(w+1), :down} } +
    (0..w).map { |x| {map.size+x, :up} }
puts "Part 2: #{b.map{|b| beam_me_up(b, map)}.map(&.map(&.[0]).uniq.size).max - 1}"
