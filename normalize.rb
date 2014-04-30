#!/usr/bin/ruby

["Education.dat", "Research_Lab.dat", "Software_Industry.dat"].each do |dat|
  max = 0
  File.foreach(dat) do |line|
    date, abs = line.chomp.split(" ").map { |d| d.to_i }
    max = [max, abs].max
  end
  File.open(dat + ".normalized", "w") do |output|
    File.foreach(dat) do |line|
      date, abs = line.chomp.split(" ").map { |d| d.to_i }
      output.puts "#{date} #{abs * 1.0 / max}"
    end
  end
end
