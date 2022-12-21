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

  def xy
    [x, y]
  end
end

class SensorBeaconPair
  def initialize(sensor:, beacon:)
    @sensor = sensor
    @beacon = beacon
    @coverage_distance = sensor.distance_to(beacon)
  end
  attr_accessor :sensor, :beacon, :coverage_distance

  def outer_border
    return @border if defined?(@border)

    @border = []
    (sensor.x - coverage_distance - 1).upto(sensor.x + coverage_distance + 1) do |x|
      y = sensor.y - (coverage_distance - (sensor.x - x).abs) - 1
      @border << Coords.new(x: x, y: y).xy
      y = sensor.y + (coverage_distance - (sensor.x - x).abs) + 1
      @border << Coords.new(x: x, y: y).xy
    end

    @border = @border.uniq
  end

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

  $beacon_sensor_pairs << beacon_sensor_pair
end

# pair off all of the possible combinations of SensorBeaconPairs
# so we don't waste time checking the same pairs twice
$pairs_of_pairs = []
$beacon_sensor_pairs.each do |pair|
  $beacon_sensor_pairs.each do |pair2|
    next if pair == pair2

    $pairs_of_pairs << [pair, pair2].to_set
  end
end
$pairs_of_pairs = $pairs_of_pairs.uniq

# find all of the beacon range borders that are touching and check for beacons
$possible_beacon_coords = nil
$pairs_of_pairs.each do |set|
  (a, b) = set.to_a
  # early return if their range reach isn't one pixel apart
  distance_between_sensors = a.sensor.distance_to(b.sensor) - 1
  touching = distance_between_sensors - a.coverage_distance - b.coverage_distance == 1
  next unless touching

  border1 = a.outer_border
  border2 = b.outer_border
  intersecting_coords = border1 & border2

  intersecting_coords.each do |coords|
    next if $beacon_sensor_pairs.any? do |pair|
      pair.within_sensor_coverage?(Coords.new(x: coords[0],y: coords[1]))
    end

    $possible_beacon_coords = coords
  end

  break unless $possible_beacon_coords.nil?
end

puts $possible_beacon_coords[0] * 4_000_000 + $possible_beacon_coords[1]
