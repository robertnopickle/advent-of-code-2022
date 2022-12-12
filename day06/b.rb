signal = File.read("day06/sample.txt").chars
marker = nil

signal.each.with_index(13) do |c, i|
  marker = signal[i-13..i].uniq.length == 14 ? i + 1 : nil
  break if marker
end

puts marker
