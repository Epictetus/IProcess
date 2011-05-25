desc 'Run test suite.'
task :test do
  $LOAD_PATH.unshift './lib'
  require 'barney'
  require 'minitest/spec'
  require 'minitest/autorun'
  Dir.glob("test/suite/lib/**/*.rb").each { |test| require "./#{test}" }
end

task :default => :test

task :rvm_test do
  puts `rvm 1.8.7,rbx-1.2.2,1.9.2 exec rake test`
end
