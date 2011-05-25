#!/usr/bin/env ruby
require 'barney'

Barney do
  name = "Robert"
  share :name

  fork do
    name.slice! 3..5
  end

  p name # "Rob"
end


