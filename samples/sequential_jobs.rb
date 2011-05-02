#!/usr/bin/env ruby
require 'barney'

Barney.share :queue
queue = []

%w(1 2 3).each do |num|
  pid = Barney.fork do 
    queue.push num 
  end

  Process.wait pid
  Barney.sync
end

p queue # ["1", "2" ,"3"]


