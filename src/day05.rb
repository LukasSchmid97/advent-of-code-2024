# frozen_string_literal: true

input_string = nil
File.open 'input/day05.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "47|53
# 97|13
# 97|61
# 97|47
# 75|29
# 61|13
# 75|53
# 29|13
# 97|29
# 53|29
# 61|53
# 97|53
# 61|29
# 47|13
# 75|47
# 97|75
# 47|61
# 75|61
# 47|29
# 75|13
# 53|13

# 75,47,61,53,29
# 97,61,53,29,13
# 75,29,13
# 75,97,47,61,53
# 61,13,29
# 97,13,75,29,47"

rule_inputs, puzzle_inputs = input_string.split("\n\n")
rules = rule_inputs.split("\n").collect { |r| r.split('|') }
puzzles = puzzle_inputs.split("\n").collect { |p| p.split(',') }

following_check = rules.group_by(&:first).transform_values { |vs| vs.collect(&:last) }
previous_check = rules.group_by(&:last).transform_values { |vs| vs.collect(&:last) }

mid_sum = 0
fixed_mid_sum = 0
puzzles.each do |puzzle|
  fixed_puzzle = puzzle.dup
  puzzle_index = 0
  while puzzle_index < puzzle.size
    num = fixed_puzzle[puzzle_index]
    prev_nums = fixed_puzzle[...puzzle_index]
    following_nums = fixed_puzzle[(puzzle_index+1)..]
    prev_violations = prev_nums.intersection(following_check[num].to_a)
    following_violations = following_nums.intersection(previous_check[num].to_a)
    if following_violations.any?
      fixed_puzzle = fixed_puzzle[0...puzzle_index] + fixed_puzzle[(puzzle_index + 1)..]
      fixed_puzzle.insert(fixed_puzzle.index(following_violations.last) + 1, num)
      puzzle_index -= 1
    elsif prev_violations.any?
      fixed_puzzle = fixed_puzzle[0...puzzle_index] + fixed_puzzle[(puzzle_index + 1)..]
      fixed_puzzle.insert(fixed_puzzle.index(prev_violations.first), num)
      puzzle_index = [0, fixed_puzzle.index(num) - 1].max
    end
    puzzle_index += 1
  end
  if fixed_puzzle == puzzle
    mid_sum += puzzle[puzzle.size / 2].to_i
  else
    fixed_mid_sum += fixed_puzzle[fixed_puzzle.size / 2].to_i
  end
end

puts mid_sum
puts fixed_mid_sum
