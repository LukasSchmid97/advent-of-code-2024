# frozen_string_literal: true

input_string = nil
File.open 'input/day01_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "3   4
# 4   3
# 2   5
# 1   3
# 3   9
# 3   3"

arr_left = []
arr_right = []
input_string.split("\n").each do |line|
  left, right = line.split
  arr_left << left.to_i
  arr_right << right.to_i
end

sorted_left = arr_left.sort
sorted_right = arr_right.sort
difference = 0
difference_part2 = 0
arr_left.size.times do |i|
  difference += (sorted_left[i] - sorted_right[i]).abs
  difference_part2 += sorted_left[i] * sorted_right.count(sorted_left[i])
end

puts difference
puts difference_part2
