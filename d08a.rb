# make a two-dimensional array of the tree heights, with each row being a layer
map_of_tree_heights = File.read("input/d08.txt").split("\n").map { |line| line.split("").map(&:to_i) }
visible_trees_count = 0

map_of_tree_heights.each.with_index do |row, r_i|
  row.each.with_index do |tree, c_i|
    coord = [r_i, c_i]

    # if the tree is on the edge, it's visible
    if c_i == 0 ||
      c_i == row.length - 1 ||
      r_i == 0 ||
      r_i == map_of_tree_heights.length - 1
        visible_trees_count += 1
        next
    end

    # check if the tree is visible from the left
    if row.slice(0, c_i).all? { |t| t < tree }
      visible_trees_count += 1
      next
    end

    # check if the tree is visible from the right
    if row.slice(c_i + 1, row.length - 1).all? { |t| t < tree }
      visible_trees_count += 1
      next
    end

    #check if the tree is visible from the top
    if map_of_tree_heights.slice(0, r_i).all? { |row| row[c_i] < tree }
      visible_trees_count += 1
      next
    end

    #check if the tree is visible from the bottom
    if map_of_tree_heights.slice(r_i + 1, map_of_tree_heights.length - 1).all? { |row| row[c_i] < tree }
      visible_trees_count += 1
      next
    end
  end
end

puts visible_trees_count
