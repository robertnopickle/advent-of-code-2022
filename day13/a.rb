distress_signal = File.read(ENV.fetch('input')).split("\n\n")
packets = distress_signal.map { |pair| pair.split("\n").map { |line| eval(line) } }
$tracker = nil # global variable to track if the packet order is correct

def packet_order_correct?(left, right)
  return $tracker unless $tracker.nil? # stop if we already know it's wrong or right

  if left.nil? || right.nil? # one is nil
    if left.nil? && right
      $tracker = true
    elsif right.nil? && left
      $tracker = false
    end
  elsif left.is_a?(Integer) && right.is_a?(Integer) # both are integers
    $tracker = left < right unless left == right
  else # keep going...
    left = left.is_a?(Integer) ? [left] : left
    right = right.is_a?(Integer) ? [right] : right
    # loop recursively...
    max_size = [left.size, right.size].max
    max_size.times do |i|
      packet_order_correct?(left[i], right[i])
    end
  end
end

packet_tests = []
packets.each do |packet|
  packet_order_correct?(packet[0], packet[1])
  packet_tests << $tracker
  $tracker = nil
end

# turn nil into true
packet_tests.map!.with_index { |test, i| i + 1 if test == true || test.nil? }.select! { |test| test.is_a?(Integer) }
puts packet_tests.sum
