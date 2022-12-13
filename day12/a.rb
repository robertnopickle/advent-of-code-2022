# Dijkstra’s Shortest Path Algorithm
# https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

topo_map = File.read(ENV.fetch("input")).split("\n").map { |x| x.split("") }
ELEVATIONS = ("a".."z").to_a.freeze
$impossible_distance = topo_map.flatten.length + 2
$starting_node = nil
$ending_node = nil
$visited = []
$unvisited = []

def get_value(letter)
  return 0 if letter == "S"
  return 25 if letter == "E"
  ELEVATIONS.index(letter)
end

class Node
  def initialize(x, y, value)
    @x = x
    @y = y
    @value = value
    @distance_to_start = $impossible_distance
    @previous_node = nil
  end
  attr_reader :x, :y, :value
  attr_accessor :distance_to_start, :previous_node

  def count_of_previous_nodes
    return 0 if previous_node.nil?
    1 + previous_node.count_of_previous_nodes
  end

  def can_reach_neighbor?(neighbor)
    neighbor.value - 1 <= value
  end
end

# parse file into a hash of nodes,
# collecting the starting and ending coordinates
# and adding all nodes to the unvisited set
topo_map.each.with_index do |row, y|
  row.each.with_index do |letter, x|
    value = get_value(letter)
    node = Node.new(x, y, value)
    if letter == "S"
      $starting_node = node
      $starting_node.distance_to_start = 0
    elsif letter == "E"
      $ending_node = node
    end
    $unvisited << node
  end
end

def find_unvisited_neighbors(node)
  neighbors = []
  neighbors << [node.x, node.y - 1]
  neighbors << [node.x, node.y + 1]
  neighbors << [node.x - 1, node.y]
  neighbors << [node.x + 1, node.y]
  $unvisited.select { |x| neighbors.include?([x.x, x.y]) }
end

until $unvisited.empty?
  current_node = $unvisited.min_by { |x| x.distance_to_start }
  current_neighbors = find_unvisited_neighbors(current_node)
  current_neighbors.each do |neighbor|
    next unless current_node.can_reach_neighbor?(neighbor)
    tentative_distance = current_node.distance_to_start + 1
    if tentative_distance < neighbor.distance_to_start
      neighbor.distance_to_start = tentative_distance
      neighbor.previous_node = current_node
    end
  end
  $visited << current_node
  $unvisited.delete(current_node)
end

puts "path length: #{$ending_node.count_of_previous_nodes}"
