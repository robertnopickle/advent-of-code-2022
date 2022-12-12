MODES = {
  "LATEST_WITH_TEST=1" => :latest_test,
  "LATEST_WITH_SAMPLE=1" => :latest_sample
}

mode = MODES[ARGV.first] || :latest_test # default to latest test
$day = Dir.glob("day*").sort.last
$part = Dir.glob("#{$day}/*.rb").sort.last

if $part.nil? # go to previous day since there is no part file found in this day's folder...
  $day = Dir.glob("day*").sort[-2]
  $part = Dir.glob("#{$day}/*.rb").sort.last
end

$input = mode == :latest_test ? Dir.glob("#{$day}/test.txt").sort.last : Dir.glob("#{$day}/sample.txt").sort.last

# handle any nil values with a message and exit
if [$day, $part, $input].any?(&:nil?)
  puts "Something went wrong!"
  puts "Attempted to run #{$part} with #{$input}"
  exit
end

ENV["input"] = $input
puts "=================================="
puts
puts "Running #{$part} with #{$input}..."
require "./#{$part}"
puts
puts "=================================="
