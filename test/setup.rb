require 'barney'
gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
Dir.glob("test/helpers/**/*.rb").each { |helper| require "./#{helper}" }
Dir.glob("test/suite/lib/**/*.rb").each { |test| require "./#{test}" }
