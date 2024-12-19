# frozen_string_literal: true

input_string = nil
File.open 'input/day19.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "r, wr, b, g, bwu, rb, gb, br

# brwrr
# bggr
# gbbr
# rrbgbr
# ubwu
# bwurrg
# brgr
# bbrgwb"

availables, patternss = input_string.split("\n\n")
AVAILABLE = availables.split(', ')
patterns = patternss.split("\n")

def path_count(pattern, path_counter = {})
  if path_counter.keys.include?(pattern)
    return path_counter[pattern]
  elsif pattern.size == 0
    return 1
  else
    return path_counter[pattern] = AVAILABLE.sum do |subp|
      pattern.start_with?(subp) && path_count(pattern[subp.size..], path_counter) || 0
    end
  end
end

path_lengths = patterns.collect { |pattern| path_count(pattern) }

puts path_lengths.count(&:positive?)
puts path_lengths.sum
