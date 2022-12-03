rucksacks = File.read("input/d03-1.txt").split("\n")

sum_of_priority_values = 0
# creating an array where "a" is index 1, "b" is index 2, ..., "A" is index 27, "B" is index 28, etc.
priority_value = [''] + ('a'..'z').to_a + ('A'..'Z').to_a

rucksacks.each do |rucksack|
  # make an array of two strings from rucksack, splitting the string exactly in half
  compartments = rucksack.scan(/.{1,#{rucksack.length/2}}/)

  # find the common letter in each compartment
  common_letter = compartments[0].chars.select { |letter| compartments[1].include?(letter) }[0]
  sum_of_priority_values += priority_value.index(common_letter)
end

puts sum_of_priority_values