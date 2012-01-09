require 'bundler/gem_tasks'

desc 'Run test suite.'
task :test do
  $LOAD_PATH.unshift './lib'
  require './test/setup'
end

task :default => :test

