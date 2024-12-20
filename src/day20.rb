# frozen_string_literal: true

input_string = nil
File.open 'input/day20.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

#input_string = "###############
##...#...#.....#
##.#.#.#.#.###.#
##S#...#.#.#...#
########.#.#.###
########.#.#...#
########.#.###.#
####..E#...#...#
####.#######.###
##...###...#...#
##.#####.#.###.#
##.#...#.#.#...#
##.#.#.#.#.#.###
##...#...#...###
################"

MAZE = input_string.split("\n").collect do |row|
  row.split('')
end

MIN_DIST = MAZE.collect do |row|
  row.collect { Float::INFINITY }
end

DIRECTIONS = [
    [0, 1],
    [1, 0],
    [-1, 0],
    [0, -1]
]

start_pos = nil
end_pos = nil

MAZE.each_with_index do |row, y|
  row.each_with_index do |value, x|
    if value == 'S'
      start_pos = [x, y]
    elsif value == 'E'
      end_pos = [x, y]
    end
  end
end
MIN_DIST[start_pos[1]][start_pos[0]] = 0

def inbounds?(pos_x, pos_y)
  pos_x >= 0 && pos_x < MAZE.first.size && pos_y >= 0 && pos_y < MAZE.size
end

# start at end
# number every field for distance to end
# for every field go straight into the adjacent walls
# O(3n)
# log end_pos_distance - start_pos_distance = saved
# select (> 15 (> 100)).count

todo = [start_pos]
valid_fields = Set.new([start_pos])
while todo.any?
  cur_pos = todo.shift
  DIRECTIONS.each do |dx, dy|
    new_pos = [cur_pos[0] + dx, cur_pos[1] + dy]
    if MAZE[new_pos[1]][new_pos[0]] != "#"
      cur_path_distance = MIN_DIST[cur_pos[1]][cur_pos[0]] + 1
      if cur_path_distance < MIN_DIST[new_pos[1]][new_pos[0]]
        MIN_DIST[new_pos[1]][new_pos[0]] = cur_path_distance
        todo << new_pos
        valid_fields << new_pos
      end
    end
  end
end

# puts MIN_DIST[end_pos[1]][end_pos[0]]

time_saves = []
valid_fields.each do |vf|
  DIRECTIONS.each do |dx, dy|
    new_pos = [vf[0] + dx, vf[1] + dy]
    if MAZE[new_pos[1]][new_pos[0]] == "#"
      new_pos_2 = [vf[0] + dx + dx, vf[1] + dy + dy]
      next unless inbounds?(new_pos_2[0], new_pos_2[1])
      if MAZE[new_pos_2[1]][new_pos_2[0]] != "#"
        time_saved = MIN_DIST[new_pos_2[1]][new_pos_2[0]] - MIN_DIST[vf[1]][vf[0]] - 2
        if time_saved > 0
          time_saves << time_saved
        end
      end
    end
  end
end

puts time_saves.select { |t| t >= 100 }.count

# part 2
# at every step
# collect all valid steps in a 20 step radius
# collect differences

def field_values(posx, posy)
  start_val_y = [posy - 20, 0].max
  MIN_DIST[start_val_y..(posy + 20)].each_with_index.collect do |row, ri|
    dy = (posy - start_val_y - ri).abs
    start_val_x = [posx - 20, 0].max
    row[start_val_x..(posx + 20)].each_with_index.collect do |val, ci|
      dist = (posx - start_val_x - ci).abs + dy
      [val, dist] if dist <= 20 && val != Float::INFINITY
    end.compact
  end.flatten(1)
end


huge_time_saves = []
valid_fields.each do |vf|
  current_value = MIN_DIST[vf[1]][vf[0]]
  search_values = field_values(vf[0], vf[1])
  huge_time_saves += search_values.collect { |sv, dist| sv - current_value - dist }.select { |v| v > 0 }
end

# puts huge_time_saves.group_by(&:itself).transform_values { |vs| vs.count }.sort_by(&:first).inspect
puts huge_time_saves.select { |t| t >= 100 }.count
