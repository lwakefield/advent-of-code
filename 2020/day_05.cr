def get_seat (str)
  row_start, row_stop = 0, 127
  str[0..6].each_char do |c|
    if c == 'F'
        row_stop -= (row_stop - row_start) // 2
        row_stop -= 1
    else
        row_start += (row_stop - row_start) // 2
        row_start += 1
    end
    # puts "#{row_start}..#{row_stop}"
  end

  col_start, col_stop = 0, 7
  str[7..9].each_char do |c|
    if c == 'L'
        col_stop -= (col_stop - col_start) // 2
        col_stop -= 1
    else
        col_start += (col_stop - col_start) // 2
        col_start += 1
    end
    # puts "#{col_start}..#{col_stop}"
  end

  { row_start, col_start }
end

def seat_id (pos)
    pos[0] * 8 + pos[1]
end

def draw_seats (rows)
    rows.each_with_index do |row, index|
        puts "#{index.to_s.ljust(4)} #{row.join}"
    end
end

max_id = 0
rows = Array(Array(Char)).new(128) { |i| [' '] * 8 }

File.each_line("day_05.txt") do |line|
    seat = get_seat(line)

    if seat_id(seat) > max_id
        max_id = seat_id(seat)
    end

    rows[seat[0]][seat[1]] = 'x'
end

draw_seats(rows)

# 66 * 8 + 6
