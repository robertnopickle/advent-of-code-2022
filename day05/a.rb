input = File.read(ENV.fetch("input")).split("\n")

number_of_crate_stacks = input[0].length / 4 + 1
crate_stacks = []
number_of_crate_stacks.times { crate_stacks << [] }
moves = []

input.each do |line|
  # parse the crate stacks into two-dimensional array
  unless line[0] == "m" || line.empty?
    number_of_crate_stacks.times do |i|
      position = i * 4
      if line[position] == "["
        crate_stacks[i] << line[position + 1]
      end
    end
  end

  # parse the moves into an array of hashs
  if line[0] == "m"
    cmd = {}
    line.split(" ").each_slice(2) { |k, v| cmd[k] = k == "move" ? v.to_i : v.to_i - 1 }
    moves << cmd
  end
end

# process the moves
moves.each do |cmd|
  picked_up_crates = crate_stacks[cmd["from"]].shift(cmd["move"]).reverse
  crate_stacks[cmd["to"]] = picked_up_crates + crate_stacks[cmd["to"]]
end

# read the top crate of each stack
puts crate_stacks.map(&:first).join
