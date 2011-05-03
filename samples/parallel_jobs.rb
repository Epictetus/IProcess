#/usr/bin/env ruby
require 'barney'

Barney.share :message
message = ""

%w(r u b y).each do |letter|
  Barney.fork do 
    message << letter
  end
end

Barney.wait_all
Barney.sync

message = Barney.history.map(&:value).join
p message # "ruby"
