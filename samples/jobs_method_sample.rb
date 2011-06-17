#!/usr/bin/env ruby
require 'barney'

number  = 21 
results = Jobs(5) { number + number }
p results # => [42, 42, 42, 42, 42]
