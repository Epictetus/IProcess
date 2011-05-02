#/usr/bin/env ruby
require 'barney'

Barney.share :message
message = ""
pids    = []

%w(r u b y).each do |letter|
  pids << Barney.fork do 
    message << letter
  end
end

pids.each do |pid| 
  Process.wait pid 
end

Barney.sync
message = Barney.history.map(&:value).join

p message # "ruby"
