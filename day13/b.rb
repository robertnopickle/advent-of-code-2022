distress_signal = File.read(ENV.fetch('input')).split("\n\n")
packets = distress_signal.map { |pair| pair.split("\n").map { |line| eval(line) } }.flatten(1)
$tracker = nil # global variable to track if the packet order is correct
$divider_packet_one = [[2]]
$divider_packet_two = [[6]]

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

# add in the divider packets
packets << $divider_packet_one
packets << $divider_packet_two

packets.sort! do |left, right|
  $tracker = nil
  packet_order_correct?(left, right)
  if $tracker
    -1
  else
    1
  end
end

puts (packets.index($divider_packet_one) + 1) * (packets.index($divider_packet_two) + 1)
