# find the latest day folder and run the alphabetally last file in it
day_folder = Dir.glob("day*").sort.last
file = Dir.glob("#{day_folder}/*.rb").sort.last

puts "Running #{file}..."

require "./#{file}"
