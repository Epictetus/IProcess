#!/usr/bin/env ruby
require 'barney'

str = "12"

obj = Barney::Share.new
obj.share :str

%w(3 4).each do |num|
  pid = obj.fork { str << num }
  Process.wait pid
  obj.sync
end

puts str # "1234"


