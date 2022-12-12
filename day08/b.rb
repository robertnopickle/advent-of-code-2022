# make a two-dimensional array of the tree heights, with each row being a layer
map_of_tree_heights = File.read("day08/sample.txt").split("\n").map { |line| line.split("").map(&:to_i) }
best_scenic_score = 0

# method that counts the number of given trees visible from a given tree
def count_visible_trees(trees:, tree:)
  count = 0
  trees.each do |t|
    count += 1
    break if t >= tree
  end
  count
end

# go through all of the trees and check if they have a better scenic score than the current best
map_of_tree_heights.each.with_index do |row, r_i|
  row.each.with_index do |tree, c_i|
    trees_to_the_west = row.slice(0, c_i).reverse
    trees_to_the_east = row.slice(c_i + 1, row.length - 1)
    trees_to_the_north = map_of_tree_heights.slice(0, r_i).reverse.map { |row| row[c_i] }
    trees_to_the_south = map_of_tree_heights.slice(r_i + 1, map_of_tree_heights.length - 1).map { |row| row[c_i] }

    scenic_score = [trees_to_the_west, trees_to_the_east, trees_to_the_north, trees_to_the_south].map do |trees|
      count_visible_trees(trees: trees, tree: tree)
    end.inject(:*)

    best_scenic_score = scenic_score if scenic_score > best_scenic_score
  end
end

puts best_scenic_score
