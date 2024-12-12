# frozen_string_literal: true

input_string = nil
File.open 'input/day07.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "190: 10 19
# 3267: 81 40 27
# 83: 17 5
# 156: 15 6
# 7290: 6 8 6 15
# 161011: 16 10 13
# 192: 17 8 14
# 21037: 9 7 18 13
# 292: 11 6 16 20"

def adds_up_to(operands, value, part2: false)
  return false if operands[0] > value
  return operands.first == value if operands.count == 1
  return adds_up_to([operands[0] + operands[1], *operands[2..]], value, part2: part2) \
          || adds_up_to([operands[0] * operands[1], *operands[2..]], value, part2: part2) \
          || (part2 && adds_up_to(["#{operands[0]}#{operands[1]}".to_i, *operands[2..]], value, part2: true))
end


possible_sum = 0
possible_sum2 = 0
input_string.split("\n").collect do |equation|
  target, operands_text = equation.split(': ')
  target = target.to_i
  operands = operands_text.split.collect(&:to_i)
  if adds_up_to(operands, target)
    possible_sum += target
  end
  if adds_up_to(operands, target, part2: true)
    possible_sum2 += target
  end
end

puts possible_sum
puts possible_sum2
