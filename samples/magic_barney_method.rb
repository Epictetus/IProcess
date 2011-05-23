#!/usr/bin/env ruby
#
# Magic "Barney" method

require 'barney'

Barney do
  name = "Robert"
  share :name

  fork do
    name.slice! 3..5
  end
end
