#!/usr/bin/env ruby
#
# Magic "Barney" method

require 'barney'

name = 'Robert'

Barney do
  share :name

  fork do
    name.slice! 3..5
  end
end

p name # "Rob"
