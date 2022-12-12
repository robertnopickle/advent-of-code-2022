moves = File.read(ENV.fetch("input")).split("\n")

$knots = []
$tail_positions = ["0,0"]

class Knot
  DIRECTION_KEY = { "R" => :right, "L" => :left, "U" => :up, "D" => :down }

  def initialize(next_knot: nil)
    @x = 0
    @y = 0
    @next_knot = next_knot
  end
  attr_accessor :x, :y, :next_knot

  def move(direction, diagonal_move = false)
    case DIRECTION_KEY[direction]
    when :right
      @x += 1
    when :left
      @x -= 1
    when :up
      @y += 1
    when :down
      @y -= 1
    end

    # record the position if this is the tail knot and it wasn't the first part of a diagonal move
    unless diagonal_move
      $tail_positions << "#{x},#{y}" if tail?
      move_next_knot unless tail? || touching_next_knot?
    end
  end

  private

  def move_next_knot
    # if next knot is to be diagonally moved, we want to skip triggering the recursively triggered next knot move
    # until the second part of that diagonal move is complete
    diagonal_move = x != next_knot.x && y != next_knot.y

    if x > next_knot.x
      next_knot.move("R", diagonal_move)
    elsif x < next_knot.x
      next_knot.move("L", diagonal_move)
    end

    if y > next_knot.y
      next_knot.move("U")
    elsif y < next_knot.y
      next_knot.move("D")
    end
  end

  def touching_next_knot?
    touching_range = (-1..1)
    touching_range.include?(next_knot.x - x) && touching_range.include?(next_knot.y - y)
  end

  def tail?
    next_knot.nil?
  end
end

# make ten knots in a row, with references to their next knot...
10.times do
  $knots.unshift(Knot.new(next_knot: $knots.first))
end

# process moves
moves.each do |move|
  direction, distance = move.split(" ")
  distance = distance.to_i
  distance.times { $knots[0].move(direction) }
end

puts $tail_positions.uniq.count
