file_data = File.read("input/d01.txt").split("\n\n")

# go through each elf and sum the food item calories, creating an array of sums by elf
summed_calories_by_elf = file_data.map do |elf|
  elf.split("\n").map(&:to_i).sum
end

# output the largest sum in the array
puts summed_calories_by_elf.sort!.last
