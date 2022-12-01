file_data = File.read("d1-1.txt").split("\n\n")

# go through each elf and sum the food item calories, creating an array of sums by elf
summed_calories_by_elf = file_data.map do |elf|
  elf.split("\n").map(&:to_i).sum
end

# output the sum of the largest three in the array
puts summed_calories_by_elf.sort!.reverse!.take(3).sum
