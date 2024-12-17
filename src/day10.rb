# frozen_string_literal: true

input_string = nil
File.open 'input/day10.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "89010123
# 78121874
# 87430965
# 96549874
# 45678903
# 32019012
# 01329801
# 10456732"

input_rows = input_string.split("\n")
INPUT_MAP = input_rows.collect do |row|
  row.split('').collect(&:to_i)
end

trailhead_score_map = INPUT_MAP.collect do |row|
  row.collect { nil }
end

def inbounds?(pos_x, pos_y)
  pos_x >= 0 && pos_x < INPUT_MAP.first.size && pos_y >= 0 && pos_y < INPUT_MAP.size
end

def step_up(pos_x, pos_y, trailhead_score_map)
  # memoization via trailhead_score_map could save some cycles
  current_value = INPUT_MAP[pos_y][pos_x]
  peaks = []
  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |x_diff, y_diff|
      if inbounds?(pos_x + x_diff, pos_y + y_diff)
        target_value = INPUT_MAP[pos_y + y_diff][pos_x + x_diff]
        if target_value == current_value + 1
          if target_value == 9
            peaks << [pos_x + x_diff, pos_y + y_diff]
          else
            peaks += step_up(pos_x + x_diff, pos_y + y_diff, trailhead_score_map)
          end
        end
    end
  end
  return peaks
end

peak_count_total = 0
trail_count_total = 0
INPUT_MAP.each_with_index do |row, y_index|
  row.each_with_index do |value, x_index|
    if value == 0
      puts "Starting at #{x_index},#{y_index}"
      trail_count_total += step_up(x_index, y_index, trailhead_score_map).size
      peak_count_total += step_up(x_index, y_index, trailhead_score_map).uniq.size
    end
  end
end

puts peak_count_total
puts trail_count_total
