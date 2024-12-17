# frozen_string_literal: true

input_string = nil
File.open 'input/day12.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "RRRRIICCFF
# RRRRIICCCF
# VVRRRCCFFF
# VVRCCCJFFF
# VVVVCJJCFE
# VVIVCCJJEE
# VVIIICJJEE
# MIIIIIJJEE
# MIIISIJEEE
# MMMISSJEEE"

# input_string = "AAAA
# BBCD
# BBCC
# EEEC"

# make a region list [[region_tiles, perimeter_count], ...]
# if tile not in any region:
# - BFS from tile to all similar tiles
# - if tile different, increase region perimeter
# - if tile same, add to region area and recurse

MAP = input_string.split("\n").collect do |row|
  row.split('')
end

MAX_X = MAP.first.size
MAX_Y = MAP.size

region_list = []

def inbounds?(x, y)
  x >= 0 && x < MAX_X && y >= 0 && y < MAX_Y
end

def bfs_tiles(x, y)
  current_value = MAP[y][x]
  adjacent_valids = Set.new
  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |x_diff, y_diff|
    next unless inbounds?(x + x_diff, y + y_diff)
    next_value = MAP[y + y_diff][x + x_diff]
    if next_value == current_value
      adjacent_valids << [x + x_diff, y + y_diff]
    end
  end
  return adjacent_valids
end

def corners(x, y, adjacents)
  current_value = MAP[y][x]
  # I am a corner
  corner_count = case adjacents.count
                 when 0
                   4
                 when 1
                   2
                 when 2
                   if adjacents.to_a[0][1] == adjacents.to_a[1][1] \
                       || adjacents.to_a[0][0] == adjacents.to_a[1][0]
                     0
                   else
                     1
                   end
                 when 3
                   0
                 when 4
                   0
                 end

  right_coord = [x + 1, y]
  if corner_count < 4 && inbounds?(*right_coord) && !adjacents.include?(right_coord)
    [-1, 1].each do |y_diff|
      if inbounds?(x + 1, y + y_diff) && MAP[y + y_diff][x + 1] == current_value && adjacents.include?([x, y + y_diff])
        corner_count += 1
      end
    end
  end

  left_coord = [x - 1, y]
  if corner_count < 4 && inbounds?(*left_coord) && !adjacents.include?(left_coord)
    [-1, 1].each do |y_diff|
      if inbounds?(x - 1, y + y_diff) && MAP[y + y_diff][x - 1] == current_value && adjacents.include?([x, y + y_diff])
        corner_count += 1
      end
    end
  end
  corner_count
end


MAP.each_with_index do |row, y_index|
  row.each_with_index do |value, x_index|
    if region_list.none? { |rl| rl.first.include?([x_index, y_index]) }
      current_region = Set.new([[x_index, y_index]])
      region_fences = 0
      region_corners = 0
      to_check = [[x_index, y_index]]
      while to_check.size > 0
        x_check, y_check = to_check.first
        new_tiles = bfs_tiles(x_check, y_check)
        to_check += (new_tiles - current_region).to_a
        current_region += new_tiles
        region_fences += 4 - new_tiles.count
        region_corners += corners(x_check, y_check, new_tiles)
        to_check.shift
      end
      region_list << [current_region, region_fences, region_corners]
    end
  end
end

puts region_list.sum { |region, perimeter, _| region.size * perimeter }
puts region_list.sum { |region, _, sides| region.size * sides }
