# 498,4 -> 498,6 -> 496,6
# 503,4 -> 502,4 -> 502,9 -> 494,9
# becomes a two-dimensional array of integer coordinates:
# [[[498, 4], [498, 6], [496, 6]], [[503, 4], [502, 4], [502, 9], [494, 9]]]
paths_of_rock = File.read(ENV.fetch('input')).split("\n").map { |path| path.split(" -> ").map { |coord| coord.split(",").map(&:to_i) } }
SPACE_KEY = { :air => ".", :rock => "#", :sand => "o" }
sand_source_coord = [500, 0]

# make the cave array
all_coords_list = paths_of_rock.flatten(1)
min_y = 0
max_y = all_coords_list.map { |coord| coord[1].to_i }.max + 2
min_x = sand_source_coord[0] - max_y
max_x = sand_source_coord[0] + max_y
$cave = Array.new(max_y).map { Array.new(max_x + 1) { SPACE_KEY[:air] } }
$cave << Array.new(max_x + 1) { SPACE_KEY[:rock] }

def fetch_space(x, y)
  return nil if $cave[y].nil? || $cave[y][x].nil?
  SPACE_KEY.key($cave[y][x])
end

def mark_space(x, y, type)
  $cave[y][x] = SPACE_KEY[type]
end

# fill in the cave with the rock using the paths_of_rock array
paths_of_rock.each do |path|
  $cave[path[0][1]][path[0][0]] = SPACE_KEY[:rock] # draw the first one
  path.each_with_index do |coords, index|
    ending_coords = path[index + 1]
    break if ending_coords == nil # skip the last one
    segment_distance = coords.map.with_index { |coord, index| ending_coords[index] - coord }

    until segment_distance.all?(&:zero?)
      distance_x = segment_distance[0]
      distance_y = segment_distance[1]

      if distance_x.positive?
        segment_distance[0] -= 1
        coords[0] += 1
      elsif distance_x.negative?
        segment_distance[0] += 1
        coords[0] -= 1
      elsif distance_y.positive?
        segment_distance[1] -= 1
        coords[1] += 1
      elsif distance_y.negative?
        segment_distance[1] += 1
        coords[1] -= 1
      end

      mark_space(coords[0], coords[1], :rock)
    end
  end
end

# begin the sand flow and main loop...
$landed_sand = 0
$source_clogged = false
until $source_clogged
  $sand_position = sand_source_coord.clone
  $sand_lands = false
  until $sand_lands || $source_clogged
    below = fetch_space($sand_position[0], $sand_position[1] + 1)
    diagonal_left = fetch_space($sand_position[0] - 1, $sand_position[1] + 1)
    diagonal_right = fetch_space($sand_position[0] + 1, $sand_position[1] + 1)

    # check if sand source is clogged
    if $sand_position == sand_source_coord && [below, diagonal_left, diagonal_right].all? { |space| space == :sand }
      $landed_sand += 1
      mark_space($sand_position[0], $sand_position[1], :sand)
      $sand_lands = true
      $source_clogged = true
      next
    end

    # check to see if sand moves down, diagonally left, or diagonally right
    if [below, diagonal_left, diagonal_right].any? { |space| space == :air }
      if below == :air
        $sand_position[1] += 1
      elsif diagonal_left == :air
        $sand_position[0] -= 1
        $sand_position[1] += 1
      elsif diagonal_right == :air
        $sand_position[0] += 1
        $sand_position[1] += 1
      end
      next
    end

    # check to see if sand lands on rock or sand
    if below == :rock || below == :sand
      $sand_lands = true
      $landed_sand += 1
      mark_space($sand_position[0], $sand_position[1], :sand)
      next
    end
  end
end

puts $landed_sand
