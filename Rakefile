task :test do
  $LOAD_PATH.unshift './lib'
  require 'barney'
  require 'minitest/spec'
  require 'minitest/autorun'
  begin; require 'turn'; rescue LoadError; end
  Dir.glob("test/suite/lib/**/*.rb").each { |test| require_relative test }
end
