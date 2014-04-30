#!/usr/bin/ruby

require 'csv'
require 'set'

education_labels = [
  251021, # Computer Science Teachers and Researchers, PostSecondary
  #251191 Graduate Teaching Assistants
  # Pre 1999 labels:
  31226  # "Computer Science Teachers, Postsecondary"
]

research_lab_labels = [
  151111, # Computer and Information Research Scientists (Industry)
  # No Pre 1999 labels
  # 1999 - 2009 labels:
  151011 # ,"Computer and Information Scientists, Research"
]

industry_labels = [
  # ---- Post-2009 labels: ----
  # NOTE: commenting out occupations below to remove measurement error, since they are only reported those numbers after
  # 2010. This means that our results are an underestimate!
  113021,  # Computer and Information Systems Managers
  # 150000  # Computer and Mathematical Occupations
  # 151100,  # Computer Occupations
  #151120,  # Computer and Information Analysts
  151121,  # Computer Systems Analysts
  #151122,  # Information Security Analysts
  #151130,  # Software Developers and Programmers
  151131,  # Computer Programmers
  151132,  # Software Developers, Applications
  151133,  # Software Developers, Systems Software
  #151134,  # Web Developers
  #151140,  # Database and Systems Administrators and Network Architects
  151141,  # Database Administrators
  151142,  # Network and Computer Systems Administrators
  #151143,  # Computer Network Architects
  151150,  # Computer Support Specialists
  #151151,  # Computer User Support Specialists
  #151152,  # Computer Network Support Specialists
  #151199,  # Computer Occupations, All Other
  # ----- 1999 - 2009 labels: ----
  151021, #,Computer Programmers
  151031, #,"Computer Software Engineers, Applications"
  151032, #"Computer Software Engineers, Systems Software"
  151051, #Computer Systems Analysts,
  151061, #Database Administrators
  151071, #,Network and Computer Systems Administrators
  151081, #Network Systems and Data Communications Analysts
  #439011, #Computer Operators
  # ----- Pre 1999 labels: ----
  22127, #,Computer Engineers
  25105,  #,Computer Programmers,
  25108,  #,Computer Programmer Aides,
  25111, #"Programmers, Numerical Tool and Process Control"
  25199, #All Other Computer Scientists,
  25102 #"Systems Analysts, Electronic Data Processing"
  # TODO(cs): multiple rows in these datasets!
]

def aggregate_total_employees(series_labels, csv_file, label_idx, total_idx)
  total = 0
  series_regex = /^#{series_labels.join("|")},/
  # The older csv datasets include multiple rows for each label rather than
  # putting all metrics onto one row. We know that the first metric
  # reported in each dataset is # of employees, so stop as soon as we see
  # the seconds instance of a label.
  all_labels_observed = Set.new
  CSV.foreach(csv_file) do |row|
    next if row[0].nil?
    begin
      label = row[label_idx].gsub(/[^0-9]/,'').to_i
      if series_labels.include? label
        break if all_labels_observed.include? label
        all_labels_observed.add label
        total += row[total_idx].gsub(/[^0-9]/,'').to_i
      end
    rescue ArgumentError
    end
  end
  puts "Observed labels for #{csv_file}: #{all_labels_observed.to_a}"
  total
end

def aggregate_files(series_labels)
  year2total = {}
  datasets = [["national*csv", 0, 3]] #, ["*d2.csv", 2, 4]]
  datasets.each do |regex, label_idx, total_idx|
    Dir.glob(regex).each do |csv_file|
      match = /.*(\d\d\d\d).*/.match csv_file
      if match.nil?
        match = /.*(\d\d)d2.*/.match csv_file
        year = 1900 + match[1].to_i
      else
        year = match[1].to_i
      end
      total = aggregate_total_employees(series_labels, csv_file, label_idx, total_idx)
      if total > 0
        year2total[year] = total
      end
    end
  end
  year2total
end

class Totals
  attr_accessor :name
  def initialize(name, labels)
    @name = name
    @output_filename = name + ".dat"
    @labels = labels
  end

  def output_sorted_results
    puts "===== Aggregating #{@name} ====="
    year2total = aggregate_files(@labels)

    File.open(@output_filename, "w") do |f|
      year2total.keys.sort.each do |key|
        # All stats are taken in May (Month: 05)
        f.puts "#{key}05 #{year2total[key]}"
      end
    end
  end
end

[
  Totals.new("Education", education_labels),
  Totals.new("Research_Lab", research_lab_labels),
  Totals.new("Software_Industry", industry_labels)
].each do |totals|
  totals.output_sorted_results
end
