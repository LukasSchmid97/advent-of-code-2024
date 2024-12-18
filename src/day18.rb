# frozen_string_literal: true

input_string = nil
File.open 'input/day18.txt' do |puzzle_in|
  input_string = puzzle_in.read
end


BYTES_CONSIDERED = 1024
TARGET_COORDS = [70, 70]

# input_string = "5,4
# 4,2
# 4,5
# 3,0
# 2,1
# 6,3
# 2,4
# 1,5
# 0,6
# 3,3
# 2,6
# 5,1
# 1,2
# 5,5
# 2,5
# 6,5
# 1,4
# 0,4
# 6,4
# 1,1
# 6,1
# 1,0
# 0,5
# 1,6
# 2,0"

# BYTES_CONSIDERED = 12
# TARGET_COORDS = [6, 6]

MAX_X = TARGET_COORDS[0] + 1
MAX_Y = TARGET_COORDS[1] + 1

MAP = (TARGET_COORDS[1] + 1).times.collect do |i|
  (TARGET_COORDS[0] + 1).times.collect { nil }
end

input_string.split("\n").take(BYTES_CONSIDERED).each do |line|
  x, y = line.split(',').collect(&:to_i)
  MAP[y][x] = false
end

MAP[0][0] = 0

# do bfs

def inbounds?(x, y)
  x >= 0 && x < MAX_X && y >= 0 && y < MAX_Y
end

def bfs(x, y, map)
  current_value = map[y][x]
  next_steps = []
  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |x_diff, y_diff|
    next unless inbounds?(x + x_diff, y + y_diff)
    next_value = map[y + y_diff][x + x_diff]
    if next_value.nil?
      map[y + y_diff][x + x_diff] = current_value + 1
      next_steps << [ x + x_diff, y + y_diff]
    end
  end
  next_steps
end

map = Marshal.load(Marshal.dump(MAP))
next_steps = [[0, 0]]
while next_steps.any?
  next_steps += bfs(*next_steps.shift, map)
end

puts map[TARGET_COORDS[1]][TARGET_COORDS[0]]

def is_solvable?(map)
  next_steps = [[0, 0]]
  while next_steps.any?
    next_steps += bfs(*next_steps.shift, map)
  end
  return !map[TARGET_COORDS[1]][TARGET_COORDS[0]].nil?
end

#binary search for the fatal block
MIN_BYTES = BYTES_CONSIDERED
MAX_BYTES = input_string.split("\n").size

cur_min = MIN_BYTES
cur_max = MAX_BYTES

while cur_max > cur_min + 1
  cur_bytes = cur_min + (cur_max - cur_min)/2
  tmp_map = Marshal.load(Marshal.dump(MAP))

  input_string.split("\n").take(cur_bytes).each do |line|
    x, y = line.split(',').collect(&:to_i)
    tmp_map[y][x] = false
  end

  if is_solvable?(tmp_map)
    cur_min = cur_bytes
  else
    cur_max = cur_bytes
  end
  puts [cur_min, cur_max].inspect
end

puts input_string.split("\n")[cur_max - 1]
