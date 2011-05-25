#!/usr/bin/env ruby
require 'barney'

results = Jobs(3) { 21+21; sleep(100) }
p results
