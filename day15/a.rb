positions = File.read(ENV.fetch('input')).split("\n")

class Coords
  def initialize(x: 0, y: 0)
    @x = x
    @y = y
  end
  attr_accessor :x, :y

  def distance_to(c)
    (x - c.x).abs + (y - c.y).abs
  end

  def eql?(c)
    x == c.x && y == c.y
  end
end

$min_xy = Coords.new
$max_xy = Coords.new

def check_max_and_min_against_coords(coords)
  $min_xy.x = coords.x if coords.x < $min_xy.x
  $max_xy.x = coords.x if coords.x > $max_xy.x
  $max_xy.y = coords.y if coords.y > $max_xy.y
  $min_xy.y = coords.y if coords.y < $min_xy.y
end

def check_beacon_sensor_pair_max_and_min(beacon_sensor_pair)
  check_max_and_min_against_coords(beacon_sensor_pair.sensor)
  check_max_and_min_against_coords(beacon_sensor_pair.beacon)
  max_x = beacon_sensor_pair.sensor.x + beacon_sensor_pair.coverage_distance
  max_y = beacon_sensor_pair.sensor.y + beacon_sensor_pair.coverage_distance
  min_x = beacon_sensor_pair.sensor.x - beacon_sensor_pair.coverage_distance
  min_y = beacon_sensor_pair.sensor.y - beacon_sensor_pair.coverage_distance
  check_max_and_min_against_coords(Coords.new(x: max_x, y: max_y))
  check_max_and_min_against_coords(Coords.new(x: min_x, y: min_y))
end

class SensorBeaconPair
  def initialize(sensor:, beacon:)
    @sensor = sensor
    @beacon = beacon
    @coverage_distance = sensor.distance_to(beacon)
  end
  attr_accessor :sensor, :beacon, :coverage_distance

  def within_sensor_coverage?(coords)
    sensor.distance_to(coords) <= coverage_distance
  end
end

# go through all of the positions and make SensorBeaconPairs
$beacon_sensor_pairs = []
positions.each do |p|
  pairs = p.gsub("Sensor at ", "")
    .gsub("closest beacon is at ", "")
    .gsub("x=", "")
    .gsub("y=", "")
    .split(": ")
    .map { |coord| coord.split(", ").map(&:to_i) }

  sensor = Coords.new(x: pairs.first[0], y: pairs.first[1])
  closest_beacon = Coords.new(x: pairs.last[0], y: pairs.last[1])
  beacon_sensor_pair = SensorBeaconPair.new(sensor: sensor, beacon: closest_beacon)

  check_beacon_sensor_pair_max_and_min(beacon_sensor_pair)

  $beacon_sensor_pairs << beacon_sensor_pair
end

x_range = ($min_xy.x..$max_xy.x)
count_of_positions_where_a_beacon_cannot_be_present = 0
x_range.each do |x|
  y = ENV.fetch("input") == "day15/test.txt" ? 10 : 2000000 # this is the requested row
  coords = Coords.new(x: x, y: y)
  is_in_coverage_and_not_a_beacon = $beacon_sensor_pairs.any? do |pair|
    pair.within_sensor_coverage?(coords) && !pair.beacon.eql?(coords) && !pair.sensor.eql?(coords)
  end

  count_of_positions_where_a_beacon_cannot_be_present += 1 if is_in_coverage_and_not_a_beacon
end

puts count_of_positions_where_a_beacon_cannot_be_present
