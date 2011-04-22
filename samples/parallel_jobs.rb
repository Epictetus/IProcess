#/usr/bin/env ruby
require 'barney'

str = ""
pids = []

obj = Barney::Share.new
obj.share :str

%w(a b c).each do |letter|
  pids << obj.fork do 
    str << letter
  end
end

pids.each { |pid| Process.wait pid }
obj.sync

str = obj.history.map(&:value).join
puts str # "abc"
