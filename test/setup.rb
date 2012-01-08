require 'iprocess'
require 'minitest/spec'
require 'minitest/autorun'

alias :context :describe

Dir.glob("test/*.rb").each do |test|
  require "./#{test}"
end
