require 'barney'
require 'minitest/spec'
require 'minitest/autorun'
Dir.glob("test/suite/lib/**/*.rb").each { |test| require "./#{test}" }
