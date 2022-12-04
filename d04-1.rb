section_assignment_pairs = File.read("input/d04-1.txt").split("\n")

overlapping_total = 0

section_assignment_pairs.each do |pair|
  # make arrays of each elf's sections.  "1-3" becomes [1,2,3]
  (elf1, elf2) = pair.split(",")
  elf1 = elf1.split("-")
  elf2 = elf2.split("-")
  elf1_sections = (elf1.first..elf1.last).to_a
  elf2_sections = (elf2.first..elf2.last).to_a

  # using array subtraction to find if they overlap, example [1, 2] - [1, 2, 3] = []
  overlapping_total += 1 if (elf1_sections - elf2_sections).empty? || (elf2_sections - elf1_sections).empty?
end

puts overlapping_total
