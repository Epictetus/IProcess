task :test do
  $LOAD_PATH.unshift './lib'
  require 'barney'
  require 'minitest/spec'
  require 'minitest/autorun'
  Dir.glob("test/suite/lib/**/*.rb").each { |test| require_relative test }
end
