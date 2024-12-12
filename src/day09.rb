# frozen_string_literal: true

input_string = nil
File.open 'input/day09.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "12345"
#0..111....22222
input_string = "2333133121414131402"
#00...111...2...333.44.5555.6666.777.888899
# input_string = "222"
#00...111...2...333.44.5555.6666.777.888899
# input_string = "1313165"
# input_string = "1010101010101010101010"
# puts input_string.size

partition_info = input_string.split('').collect(&:to_i)
partitions = []

reader_pos = 0
filler_pos = partition_info.size - 1
if filler_pos % 2 == 1
  filler_pos -= 1
end

index_sum = 0
current_index = 0
current_value = 0

while reader_pos < filler_pos || reader_pos % 2 == 0
  section_count = partition_info[reader_pos]
  if reader_pos % 2 == 0 # value
    cur_value = ((reader_pos + 1) / 2)
    section_count.times do |section_index|
      index_sum += current_index * cur_value
      current_index += 1
    end
    partition_info[reader_pos] = 0
    reader_pos += 1
  else # space
    fill_value = (filler_pos + 1) / 2
    fill_volume = partition_info[filler_pos]
    if fill_volume > section_count
      partition_info[filler_pos] = fill_volume - section_count
      partition_info[reader_pos] = 0
      reader_pos += 1
    elsif section_count > fill_volume
      partition_info[reader_pos] = section_count - fill_volume
      partition_info[filler_pos] = 0
      filler_pos -= 2
    else
      partition_info[filler_pos] = 0
      filler_pos -= 2
      reader_pos += 1
    end
    [section_count, fill_volume].min.times do |section_index|
      index_sum += current_index * fill_value
      current_index += 1
    end
  end
  puts " "
end

puts
puts index_sum

# PART 1 done
