# frozen_string_literal: true

input_string = nil
File.open 'input/day17.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "Register A: 729
# Register B: 0
# Register C: 0

# Program: 0,1,5,4,3,0"

# input_string = "Register A: 2024
# Register B: 0
# Register C: 0

# Program: 0,3,5,4,3,0"

sregisters, sprogram = input_string.split("\n\n")
registers = sregisters.split("\n").collect do |reg|
  reg.split(": ").last.to_i
end

PROGRAM = sprogram.split(": ").last.split(',').collect(&:to_i)

REGISTER = {
  'A': registers[0],
  'B': registers[1],
  'C': registers[2]
}

LITERAL = ->(v){ v }
COMBO = lambda do |c|
  return c if c < 4
  case c
  when 4
    REGISTER[:A]
  when 5
    REGISTER[:B]
  when 6
    REGISTER[:C]
  when 7
    fail 'Invalid Program'
  end
end

def execute(opcode, argument)
  output = []
  case opcode
  when 0 # adv
    denominator = 2**COMBO.call(argument)
    REGISTER[:A] = REGISTER[:A].fdiv(denominator).to_i
  when 1 # bxl
    REGISTER[:B] = REGISTER[:B] ^ LITERAL.call(argument)
  when 2 # #bst
    REGISTER[:B] = COMBO.call(argument) % 8
  when 3 # jnz
    unless REGISTER[:A].zero?
      return [->(_){ LITERAL.call(argument) }, output]
    end
  when 4 # bxc
    REGISTER[:B] = REGISTER[:B] ^ REGISTER[:C]
  when 5 # out
    output << COMBO.call(argument) % 8
  when 6 # bdv
    denominator = 2**COMBO.call(argument)
    REGISTER[:B] = REGISTER[:A].fdiv(denominator).to_i
  when 7 # cdv
    denominator = 2**COMBO.call(argument)
    REGISTER[:C] = REGISTER[:A].fdiv(denominator).to_i
  end
  [->(ip) { ip + 2 }, output]
end

def run_program
  instruction_pointer = 0
  output = []
  while instruction_pointer < PROGRAM.size
    instruction = PROGRAM[instruction_pointer]
    argument = PROGRAM[instruction_pointer + 1]
    ip_update, out = execute(instruction, argument)
    instruction_pointer = ip_update.call(instruction_pointer)
    output += out
  end
  output
end
puts run_program.join(',')

# end day 1
