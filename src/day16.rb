# frozen_string_literal: true

input_string = nil
File.open 'input/day16.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

#input_string = "###############
##.......#....E#
##.#.###.#.###.#
##.....#.#...#.#
##.###.#####.#.#
##.#.#.......#.#
##.#.#####.###.#
##...........#.#
####.#.#####.#.#
##...#.....#.#.#
##.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############"

MAZE = input_string.split("\n").collect do |row|
  row.split('')
end

MIN_DIST = MAZE.collect do |row|
  row.collect { [nil, nil, nil, nil] }
end


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

# dijkstra bfs since loops

def arr_add(a, b)
  [a[0] + b[0], a[1] + b[1]]
end

start_facing = [1, 0]
def facing_index(facing)
  (2 + facing[0]) * facing[0].abs + (1 + facing[1]) * facing[1].abs
end
MIN_DIST[start_pos[1]][start_pos[0]][facing_index(start_facing)] = 0
todo = [[start_pos, start_facing]]
turns = [
  [->(x){ 1 - x.abs }, ->(y){ 1 - y.abs }],
  [->(x){ -1 + x.abs }, ->(y){ -1 + y.abs }]
]
flip = [->(x){ -x }, ->(y){ -y }]

def move(pos, facing, new_pos)
  if MAZE[new_pos[1]][new_pos[0]] != '#'
    fi = facing_index(facing)
    old_dist = MIN_DIST[new_pos[1]][new_pos[0]][fi] || 2**32
    MIN_DIST[new_pos[1]][new_pos[0]][fi] = [old_dist, MIN_DIST[pos[1]][pos[0]][fi] + 1].min
    return old_dist > MIN_DIST[new_pos[1]][new_pos[0]][fi]
  end
  false
end

while todo.any?
  # move in facing direction
  pos, facing = todo.shift
  fi = facing_index(facing)
  new_pos = arr_add(pos, facing)
  if move(pos, facing, new_pos)
    todo << [new_pos, facing]
  end
  turns.each do |turn|
    new_facing = [turn[0].call(facing[0]), turn[1].call(facing[1])]
    nfi = facing_index(new_facing)
    old_dist = MIN_DIST[pos[1]][pos[0]][nfi] || 2**32
    MIN_DIST[pos[1]][pos[0]][nfi] = [old_dist, MIN_DIST[pos[1]][pos[0]][fi] + 1000].min
    new_pos = arr_add(pos, new_facing)
    if move(pos, new_facing, new_pos)
      todo << [new_pos, new_facing]
    end
  end
  new_facing = [flip[0].call(facing[0]), flip[1].call(facing[1])]
  nfi = facing_index(new_facing)
  old_dist = MIN_DIST[pos[1]][pos[0]][nfi] || 2**32
  MIN_DIST[pos[1]][pos[0]][nfi] = [old_dist, MIN_DIST[pos[1]][pos[0]][fi] + 2000].min
  new_pos = arr_add(pos, new_facing)
  if move(pos, new_facing, new_pos)
    todo << [new_pos, new_facing]
  end
end

puts MIN_DIST[end_pos[1]][end_pos[0]].min
