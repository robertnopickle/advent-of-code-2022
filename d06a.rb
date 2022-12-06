signal = File.read("input/d06.txt").chars
marker = nil

signal.each.with_index(3) do |c, i|
  marker = signal[i-3..i].uniq.length == 4 ? i + 1 : nil
  break if marker
end

puts marker
