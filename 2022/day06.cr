signal = STDIN.gets_to_end.chars

def get_start_of_packet_marker(signal)
  signal.each_cons(4).each_with_index do |chunk, i|
    return i + 4 if chunk.to_set.size == chunk.size
  end
end

puts "part 1: #{get_start_of_packet_marker(signal)}"

def get_start_of_message_marker(signal)
  signal.each_cons(14).each_with_index do |chunk, i|
    return i + 14 if chunk.to_set.size == chunk.size
  end
end

puts "part 2: #{get_start_of_message_marker(signal)}"
