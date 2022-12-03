rucksacks = File.read("input/d03-1.txt").split("\n")

sum_of_priority_values = 0
# creating an array where "a" is index 1, "b" is index 2, ..., "A" is index 27, "B" is index 28, etc.
priority_value = [''] + ('a'..'z').to_a + ('A'..'Z').to_a

rucksacks.each_slice(3) do |group|
  # find the common letter in each group and add the priority value to the sum
  common_letter = group[0].chars.select { |l| group[1].include?(l) && group[2].include?(l) }.first
  sum_of_priority_values += priority_value.index(common_letter)
end

puts sum_of_priority_values
