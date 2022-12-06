signal = File.read("input/d06.txt").chars
marker = nil

signal.each.with_index(13) do |c, i|
  marker = signal[i-13..i].uniq.length == 14 ? i + 1 : nil
  break if marker
end

puts marker
