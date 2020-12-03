grid = [] of String
File.each_line("./day_03.txt") do |line|
    grid << line
end

def tree_count (grid, vel)
    grid_width = grid.first.size
    pos = {0, 0}
    tree_count = 0

    until pos[1] >= grid.size
        tree_count += 1 if grid[pos[1]][pos[0] % grid_width] == '#'
        pos = { pos[0] + vel[0], pos[1] + vel[1] }
    end

    tree_count
end

test_vels = [
    {1, 1},
    {3, 1},
    {5, 1},
    {7, 1},
    {1, 2},
]
final_res = 1
test_vels.each do |vel|
    test_res = tree_count grid, vel
    puts "#{vel} => #{test_res}"
    final_res *= test_res
end
puts "final => #{final_res}"
