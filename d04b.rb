section_assignment_pairs = File.read("input/d04.txt").split("\n")

overlapping_total = 0

section_assignment_pairs.each do |pair|
  # make two-dimensional arrays of each section.  "1-3, 4-6" becomes [[1,2,3], [4,5,6]]
  sections = pair.split(",")
  sections.map! do |section|
    section_edges = section.split("-")
    (section_edges.first..section_edges.last).to_a
  end
  
  # check if anything in one section is contained in the other using Set Intersection
  overlapping_total += 1 if (sections.first & sections.last).any?
end

puts overlapping_total
