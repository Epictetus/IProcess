#!/usr/bin/env ruby
#
# Barney module sample
# Messages are forwarded onto a single instance of Barney::Share.

require 'barney'

Barney.share :name

Barney.fork do 
  name.slice! 3..5
end

Barney.wait_all
Barney.sync

p name # "Rob"
