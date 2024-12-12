# frozen_string_literal: true

input_string = nil
File.open 'input/day08.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "F...........
# FB......0...
# .....0......
# .......0....
# ....0.......
# ......A.....
# ..........88
# ............
# CC......A...
# .B.......A..
# .B..........
# .B.........."

antenna_locations = {}
antinode_locations = Set.new
antinode_locations_part2 = Set.new

MAX_X = input_string.split("\n").first.size
MAX_Y = input_string.split("\n").size
input_string.split("\n").each_with_index do |line, index_y|
  line.split('').each_with_index do |antenna, index_x|
    next if antenna == '.'
    antenna_locations[antenna] ||= []
    antenna_locations[antenna] << [index_x, index_y]
  end
end

def valid_pos(x, y)
  x >= 0 && x < MAX_X && y >= 0 && y < MAX_Y
end

antenna_locations.each do |antenna_label, antennas|
  antennas.each do |antenna_position|
    # could be factor 2 faster
    antennas.each do |antenna_position_2|
      next if antenna_position == antenna_position_2
      antenna_vector_x = antenna_position_2[0] - antenna_position[0]
      antenna_vector_y = antenna_position_2[1] - antenna_position[1]

      [1, -1].each do |dir|
        index = 0
        loop do
          potential_location = [antenna_position_2[0] + index * dir * antenna_vector_x, antenna_position_2[1] + index * dir * antenna_vector_y]
          if valid_pos(potential_location[0], potential_location[1])
            antinode_locations_part2 << potential_location
            if dir == 1 && index == 1 || dir == -1 && index == 2
              antinode_locations << potential_location
            end
          else
            break
          end
          index += 1
        end
      end
    end
  end
end

puts antinode_locations.count
puts antinode_locations_part2.count
