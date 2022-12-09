moves = File.read("input/d09.txt").split("\n")

class Coords
  def initialize
    @x = 0
    @y = 0
  end
  attr_reader :x, :y

  def move_right
    @x += 1
  end

  def move_left
    @x -= 1
  end

  def move_up
    @y += 1
  end

  def move_down
    @y -= 1
  end

  def touching?(coords)
    touching_range = (-1..1)
    touching_range.include?(coords.x - x) && touching_range.include?(coords.y - y)
  end
end

$h = Coords.new
$t = Coords.new
$visited_tail_coords = ["0,0"] # start at 0,0

def determine_tail_position
  return if $t.touching?($h)

  if $h.x > $t.x
    $t.move_right
  elsif $h.x < $t.x
    $t.move_left
  end

  if $h.y > $t.y
    $t.move_up
  elsif $h.y < $t.y
    $t.move_down
  end

  # log the new tail position
  $visited_tail_coords << "#{$t.x},#{$t.y}"
end

moves.each do |move|
  direction, distance = move.split(" ")
  distance = distance.to_i

  distance.times do
    case direction
    when "R"
      $h.move_right
    when "L"
      $h.move_left
    when "U"
      $h.move_up
    when "D"
      $h.move_down
    end

    determine_tail_position
  end
end

puts $visited_tail_coords.uniq.count
