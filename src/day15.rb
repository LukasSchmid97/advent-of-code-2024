# frozen_string_literal: true

input_string = nil
File.open 'input/day15.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

#input_string = "########
##..O.O.#
###@.O..#
##...O..#
##.#.O..#
##...O..#
##......#
#########

#<^^>>>vv
#<v>>v<<"

#input_string = "##########
##..O..O.O#
##......O.#
##.OO..O.O#
##..O@..O.#
##O#..O...#
##O..O..O.#
##.OO.O.OO#
##....O...#
###########

#<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
#vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
#><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
#<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
#^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
#^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
#>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
#<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
#^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
#v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"

input_string = "#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^"

map, instructions = input_string.split("\n\n")

MAZE = map.split("\n").collect do |row|
  row.split('')
end

INSTRUCTIONS = instructions.split("\n").join('').split('')

DIRECTIONS = {
   'v': [0, 1],
   '>': [1, 0],
   '<': [-1, 0],
   '^': [0, -1]
}

ROBOT_POS = nil

BOXES = []
MAZE.each_with_index do |row, y|
  row.each_with_index do |value, x|
    if value == '@'
      ROBOT_POS = [x, y]
    elsif value == 'O'
      BOXES << [x, y]
    end
  end
end
BOXES_LARGE = BOXES.collect { |x,y| [x * 2, y] }

def arr_add(a, b)
  [a[0] + b[0], a[1] + b[1]]
end

def move(pos, instruction)
  move_vec = DIRECTIONS[instruction.to_sym]
  new_pos = arr_add(pos, move_vec)
  if BOXES.include?(new_pos)
    if move(BOXES[BOXES.index(new_pos)], instruction)
      pos.replace(new_pos)
      return true
    end
  else
    if MAZE[new_pos[1]][new_pos[0]] != "#"
      pos.replace(new_pos)
      return true
    end
  end
  false
end

def print_maze
  MAZE.each_with_index do |row, y|
    row.each_with_index do |value, x|
      if BOXES.include?([x, y])
        print "O"
      elsif ROBOT_POS == [x, y]
        print "@"
      elsif x == 0 || y == 0 || x == MAZE.first.size - 1 || y == MAZE.size - 1
        print "#"
      else
        print "."
      end
    end
    puts
  end
  puts
end

# puts "INITIAL STATE:"
# print_maze
INSTRUCTIONS.each do |instruction|
  move_vec = DIRECTIONS[instruction.to_sym]
  move(ROBOT_POS, instruction)
  # puts "Move #{instruction}"
  # print_maze
end

print_maze

puts BOXES.sum { |x,y| x + 100 * y }


