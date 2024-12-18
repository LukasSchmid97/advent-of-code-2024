# frozen_string_literal: true

input_string = nil
File.open 'input/day14.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

SPACE_HEIGHT = 103
SPACE_WIDTH = 101

# input_string = "p=0,4 v=3,-3
# p=6,3 v=-1,-3
# p=10,3 v=-1,2
# p=2,0 v=2,-1
# p=0,0 v=1,3
# p=3,0 v=-2,-2
# p=7,6 v=-1,-3
# p=3,0 v=-1,-2
# p=9,3 v=2,3
# p=7,3 v=-1,2
# p=2,4 v=2,-3
# p=9,5 v=-3,-3"

# SPACE_HEIGHT = 7
# SPACE_WIDTH = 11

BOTS = input_string.split("\n").collect do |line|
  poss, speeds = line.split(" ")
  pos = poss.split('=').last.split(',').collect(&:to_i)
  speed = speeds.split('=').last.split(',').collect(&:to_i)
  [pos, speed]
end

def positions_at(step)
  BOTS.collect do |pos, speed|
    end_x = (pos[0] + speed[0] * 100) % SPACE_WIDTH
    end_y = (pos[1] + speed[1] * 100) % SPACE_HEIGHT
    [end_x, end_y]
  end
end

bot_positions = positions_at(100)

QUADRANTS = [
  [0, SPACE_WIDTH/2, 0, SPACE_HEIGHT/2],                                # TOP LEFT
  [SPACE_WIDTH/2 + 1, SPACE_WIDTH, 0, SPACE_HEIGHT/2],                  # TOP RIGHT
  [0, SPACE_WIDTH/2, SPACE_HEIGHT/2 + 1, SPACE_HEIGHT],                 # BOTTOM LEFT
  [SPACE_WIDTH/2 + 1, SPACE_WIDTH, SPACE_HEIGHT/2 + 1, SPACE_HEIGHT]   # BOTTOM RIGHT
]

def in_quadrant(pos_x, pos_y)
  # 0 1
  # 2 3
  q = QUADRANTS.find { |min_x, max_x, min_y, max_y| pos_x >= min_x && pos_x <= max_x - 1 && pos_y >= min_y && pos_y <= max_y - 1 }
  QUADRANTS.index(q)
end

def paint_at(step)
  bot_positions = positions_at(step)
  SPACE_HEIGHT.times do |y|
    SPACE_WIDTH.times do |x|
      if bot_positions.include?([x, y])
        print bot_positions.count([x, y])
      else
        print '.'
      end
    end
    puts
  end
end

bot_quadrants = bot_positions.collect { |bx, by| in_quadrant(bx, by) }
# puts bot_quadrants.inspect
quadrant_count = 4.times.collect { |i| bot_quadrants.count(i) }
# puts quadrant_count.inspect
puts quadrant_count.reduce(:*)

def adjacent_depth(x, y, bot_coords, depth=0)
  return depth if depth > 10

  (-1..1).each do |j|
    (-1..1).each do |i|
      if !(j == i && i == 0) && bot_coords.include?([x + i, y + j])
        return adjacent_depth(x+i, y+j, bot_coords, depth + 1)
      end
    end
  end
  depth
end


# find lines somewhere
(1..100_000).each do |step|
  # bot_positions = positions_at(step)
  paint_at(step)
end
