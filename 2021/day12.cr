# Sun Dec 12 07:09:23 EST 2021

paths = {} of String => Set(String)
STDIN.each_line do |line|
  left, right = line.split("-")
  paths[left] ||= Set(String).new
  paths[right] ||= Set(String).new
  paths[left].add right
  paths[right].add left
end

def traverse (path, target, paths)
  neighbors = paths[path.last]
  return [] of Array(String) if neighbors.empty?

  solns = [] of Array(String)
  neighbors.each do |n|
    next if n.chars.first.lowercase? && path.includes? n

    if n == target
      solns << path + [n]
    else
      solns += traverse(path + [n], target, paths)
    end
  end

  solns
end

puts "part 1: #{traverse(["start"], "end", paths).size}"

# Sun Dec 12 07:23:32 EST 2021

def validpath (path)
  flag = false
  path.tally.each do |k, v|
    if k == path.first && v != 1
      # revisiting the start?
      return false
    elsif k.chars.first.lowercase? && v > 2
      return false
    elsif k.chars.first.lowercase? && v == 2
      # visiting a single small room twice
      return false if flag

      flag = true
    end
  end
  return true
end

# puts validpath(["start", "A", "c"])
# puts validpath(["start", "A", "c", "A"])
# puts validpath(["start", "A", "c", "A", "c"])
# puts validpath(["start", "A", "c", "A", "c", "c"])
# puts validpath(["start", "A", "c", "A", "c", "b"])
# puts validpath(["start", "A", "c", "A", "c", "b", "b"])
# exit 1

def traverse2 (path, target, paths)
  neighbors = paths[path.last]

  solns = [] of Array(String)
  neighbors.each do |n|
    soln = path + [n]
    next unless validpath soln

    if soln.last == target
      solns << soln
    else
      solns += traverse2(soln, target, paths)
    end
  end

  solns
end

pp "part 2: #{traverse2(["start"], "end", paths)}"

# Sun Dec 12 08:00:05 EST 2021
