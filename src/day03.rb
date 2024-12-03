def add_valid_muls(test_string, parse_do: false)
  matches = test_string.scan(/(?:mul\((\d+),(\d+)\))|(?:do(n't)?\(\))/)
  doing = true
  matches.sum do |match|
    case match
    in [nil, nil, nil]
      doing = true
    in [nil, nil, 'n\'t']
      doing = false
    in [a, b, nil]
      next a.to_i * b.to_i if doing || !parse_do
    end
    0
  end
end


test_string = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

puts add_valid_muls(test_string, parse_do: true)
puts add_valid_muls(File.read('input/day03_input.txt'))
puts add_valid_muls(File.read('input/day03_input.txt'), parse_do: true)
