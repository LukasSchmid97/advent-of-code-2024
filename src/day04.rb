# frozen_string_literal: true

input_string = nil
File.open 'input/day04_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "MMMSXXMASM
# MSAMXMSMSA
# AMXSXMAAMM
# MSAMASMSMX
# XMASAMXAMM
# XXAMMXXAMA
# SMSMSASXSS
# SAXAMASAAA
# MAMMMXMMMM
# MXMXAXMASX"

grid = input_string.split("\n").collect(&:chars)

def find_xmas(x_row, x_col, grid)
  targets = ["M", 'A', 'S']
  xmases = 0
  find_adjacent(x_row, x_col, targets[0], grid).each do |t_x, t_y|
    dir_x, dir_y = t_x - x_row, t_y - x_col
    next unless (0...grid.size).include?(t_x + 2*dir_x) && (0...grid.first.size).include?(t_y + 2*dir_y)
    if grid[t_x + dir_x][t_y + dir_y] == 'A' && grid[t_x + 2*dir_x][t_y + 2*dir_y] == 'S'
      xmases += 1
      # puts "Found xmas from #{x_row},#{x_col} to #{t_x},#{t_y}"
    end
  end
  xmases
end

def find_mases(x_row, x_col, grid)
  ms = find_diag(x_row, x_col, 'M', grid)
  ss = find_diag(x_row, x_col, 'S', grid)
  return 0 unless ms.count == 2 && ss.count == 2
  ms.each do |m_x, m_y|
    x_diff, y_diff = x_row - m_x, x_col - m_y
    unless ss.find { |s_x, s_y| s_x == x_row + x_diff && s_y == x_col + y_diff }
      return 0
    end
  end
  # puts "Found mases at #{x_row},#{x_col} #{grid[x_row][x_col]}"
  return 1
end

def find_adjacent(x, y, search_char, grid)
  coords = []
  (-1..1).each do |x_diff|
    (-1..1).each do |y_diff|
      next unless (0...grid.size).include?(x + x_diff) && (0...grid.first.size).include?(y + y_diff)
      if grid[x + x_diff][y + y_diff] == search_char
        coords << [x + x_diff, y + y_diff]
      end
    end
  end
  coords
end

def find_diag(x, y, search_char, grid)
  coords = []
  [-1,1].each do |x_diff|
    [-1,1].each do |y_diff|
      next unless (0...grid.size).include?(x + x_diff) && (0...grid.first.size).include?(y + y_diff)
      if grid[x + x_diff][y + y_diff] == search_char
        coords << [x + x_diff, y + y_diff]
      end
    end
  end
  coords
end

num_xmas = 0
num_x_mas = 0
grid.size.times do |row_num|
  grid[row_num].size.times do |col_num|
    if grid[row_num][col_num] == 'X'
      num_xmas += find_xmas(row_num, col_num, grid)
    elsif grid[row_num][col_num] == 'A'
      num_x_mas += find_mases(row_num, col_num, grid)
    end
  end
end

puts num_xmas
puts num_x_mas
