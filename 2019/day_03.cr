alias Grid = Hash(Tuple(Int32, Int32), Bool)
alias GridPath = Array(Tuple(Int32, Int32))

def get_grid (path : String)
        pos = {0, 0}
        grid = Grid.new

        path.split(',').each do |movement|
                dir = movement[0]
                amount = movement[1..].to_i32

                next_pos = pos.clone
                x_delta = if dir == 'L'
                                  -amount
                          elsif dir == 'R'
                                  amount
                          else
                                  0
                          end

                y_delta = if dir == 'U'
                                  amount
                          elsif dir == 'D'
                                  -amount
                          else
                                  0
                          end

                next_pos = { pos[0] + x_delta, pos[1] + y_delta }

                x_iter = if next_pos[0] < pos[0]
                                 (next_pos[0]..pos[0])
                         else
                                 (pos[0]..next_pos[0])
                         end
                y_iter = if next_pos[1] < pos[1]
                                 (next_pos[1]..pos[1])
                         else
                                 (pos[1]..next_pos[1])
                         end
                x_iter.each do |x|
                        y_iter.each do |y|
                                grid[{x, y}] = true
                        end
                end

                pos = next_pos
        end

        grid
end

def get_path (path_str : String)
        path = GridPath.new
        path << {0, 0}

        path_str.split(',').each do |movement|
                dir = movement[0]
                amount = movement[1..].to_i32

                x_delta = if dir == 'L'
                                  -amount
                          elsif dir == 'R'
                                  amount
                          else
                                  0
                          end

                y_delta = if dir == 'U'
                                  amount
                          elsif dir == 'D'
                                  -amount
                          else
                                  0
                          end

                x_delta.abs.times do
                        path << { path.last[0] + x_delta.sign, path.last[1] }
                end
                y_delta.abs.times do
                        path << { path.last[0], path.last[1] + y_delta.sign }
                end
        end

        path
end

def find_collisions (grids : Array(Grid))
        collisions = [] of Tuple(Int32, Int32)
        grids.combinations(2).each do |pair|
                left, right = pair[0], pair[1]
                left_keys = Set.new left.keys
                right_keys = Set.new right.keys

                collisions += (left_keys & right_keys).to_a
        end
        collisions.uniq
end

# grids = [] of Grid
# STDIN.each_line do |line|
#         grids << get_grid(line)
# end

# puts find_collisions(grids)
#         .map { |x, y| x.abs + y.abs }
#         .reject { |distance| distance == 0 }
#         .min

paths = [] of GridPath
STDIN.each_line do |line|
        paths << get_path(line)
end

distance = Int32::MAX

# TODO: this is slow :(
paths.combinations(2).each do |pair|
        left, right = pair[0], pair[1]
        left.each_with_index do |left_point, left_index|
                right.each_with_index do |right_point, right_index|
                        next if left_point == {0, 0}
                        next if right_point == {0, 0}
                        next if left_point != right_point

                        sum_steps = left_index + right_index

                        puts "found collision at #{left_point} with #{left_index} + #{right_index} = #{sum_steps}"

                        distance = sum_steps if sum_steps < distance
                end
        end
end
puts distance
