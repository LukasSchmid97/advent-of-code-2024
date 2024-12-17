# frozen_string_literal: true

input_string = nil
File.open 'input/day11.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "125 17"

stones = input_string.split(' ').collect(&:to_i)

def naive_blink(stones)
  new_stones = []
  stones.each do |stone_value|
    if stone_value == 0
      new_stones << 1
    elsif stone_value.to_s.size % 2 == 0
      new_stones << stone_value.to_s[...(stone_value.to_s.size / 2)].to_i
      new_stones << stone_value.to_s[(stone_value.to_s.size / 2)..].to_i
    else
      new_stones << stone_value * 2024
    end
  end
  stones.replace(new_stones)
end

def blink(stone_hash)
  new_hash = {}
  stone_hash.each do |stone_value, count|
    if stone_value == 0
      new_hash[1] ||= 0
      new_hash[1] += count
    elsif stone_value.to_s.size % 2 == 0
      new_hash[stone_value.to_s[...(stone_value.to_s.size / 2)].to_i] ||= 0
      new_hash[stone_value.to_s[...(stone_value.to_s.size / 2)].to_i] += count
      new_hash[stone_value.to_s[(stone_value.to_s.size / 2)..].to_i] ||= 0
      new_hash[stone_value.to_s[(stone_value.to_s.size / 2)..].to_i] += count
    else
      new_hash[stone_value * 2024] ||= 0
      new_hash[stone_value * 2024] += count
    end
  end
  stone_hash.replace(new_hash)
end

stone_hash = stones.uniq.to_h { |v| [v, stones.count(v)] }
25.times do
  blink(stone_hash)
end

puts stone_hash.values.sum

50.times do
  blink(stone_hash)
end

puts stone_hash.values.sum
