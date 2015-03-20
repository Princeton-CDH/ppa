#!/usr/bin/env ruby

require './hathiobject'
require 'optparse'

# Create command-line options

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: dedup.rb -i INFILE -o OUTFILE"

  opts.on( '-i', '--infile FILE', 'Read from FILE' ) do |file|
    options[:infile] = file
  end

  opts.on( '-o', '--outfile FILE', 'Write to FILE' ) do |file|
    options[:outfile] = file
  end
end

optparse.parse!

db = HathiDB.new(options[:infile])
db.write_culled(options[:outfile])

