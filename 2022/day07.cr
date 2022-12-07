lines = STDIN.gets_to_end.lines

dirs = Set(String).new
files = {} of String => Int32 # path => filesize
dir = ""
until lines.empty?
  line = lines.shift
  if line.starts_with? "$ cd "
    d = line.gsub "$ cd ", ""
    if d == ".."
      dir = dir.gsub(/\w+\/$/, "")
    elsif d.starts_with? "/"
      dir = d
    else
      dir = "#{dir}#{d}/"
    end
    dirs << dir
  else line.starts_with? "$ ls"
    until lines.empty? || lines.first.starts_with? "$ "
      size, path = lines.shift.split(" ")
      next if size == "dir"
      size = size.to_i32
      files[dir + path] = size
    end
  end
end

puts "part 1: #{dirs.reject("/").map do |d|
    files.select{|k,v| k.starts_with? d}.values.sum
end.select{|v| v <= 100000}.sum}"

dir_sizes = dirs.to_h do |d|
  {d, files.select{|k,v| k.starts_with? d}.values.sum }
end

available_disk_space = 70000000
needed_for_update = 30000000
unused = available_disk_space - dir_sizes["/"]
need_to_free = needed_for_update - unused

puts "part 2: #{dir_sizes.select{|k, v| v > need_to_free}.to_a.sort do |a,b|
  a[1] - b[1]
end.first[1]}"
