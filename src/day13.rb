# frozen_string_literal: true

input_string = nil
File.open 'input/day13.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400

# Button A: X+26, Y+66
# Button B: X+67, Y+21
# Prize: X=12748, Y=12176

# Button A: X+17, Y+86
# Button B: X+84, Y+37
# Prize: X=7870, Y=6450

# Button A: X+69, Y+23
# Button B: X+27, Y+71
# Prize: X=18641, Y=10279"

machines = input_string.split("\n\n")
MACHINES = machines.collect do |machine|
  line_a, line_b, prize = machine.split("\n")
  button_a = line_a.scan(/\d+/).collect(&:to_i)
  button_b = line_b.scan(/\d+/).collect(&:to_i)
  prize = prize.scan(/\d+/).collect(&:to_i)

  [button_a, button_b, prize]
end

a_cost = 3
b_cost = 1


costs_to_win = []
costs_to_win2 = []

def det(mat)
  # cramer
  mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0]
end

[0, 10000000000000].each do |t_mod|
  if t_mod == 0
    target = costs_to_win
  else
    target = costs_to_win2
  end
  MACHINES.each do |btna, btnb, prize|
    ax, ay = btna
    bx, by = btnb
    tx, ty = prize

    tx += t_mod
    ty += t_mod

    a_presses = det([[tx, bx], [ty, by]]).fdiv(det([[ax, bx], [ay, by]]))
    b_presses = det([[ax, tx], [ay, ty]]).fdiv(det([[ax, bx], [ay, by]]))
    if a_presses.to_i == a_presses && b_presses.to_i == b_presses
      target << a_presses * a_cost + b_presses * b_cost
    else
      target << 0
    end
  end
end


puts costs_to_win.sum
puts costs_to_win2.sum
