#!/usr/bin/ruby

sw_year2count = {}
File.foreach("Software_Industry.dat") do |line|
  year, count = line.chomp.split(" ").map { |d| d.to_i }
  sw_year2count[year] = count.to_i
end

["Education.dat", "Research_Lab.dat", ].each do |dat|
  year2count = {}
  File.foreach(dat) do |line|
    year, count = line.chomp.split(" ").map { |d| d.to_i }
    if sw_year2count.include? year
      year2count[year] = count
    end
  end
  File.open(dat + ".ratio", "w") do |output|
    year2count.keys.sort.each do |year|
      ratio = sw_year2count[year] / year2count[year]
      output.puts "#{year} #{ratio}"
    end
  end
end
