# -*- coding: UTF-8 -*-

$LOAD_PATH.unshift './lib'
require 'barney'

Gem::Specification.new do |s|
  s.name         = "barney"
  s.version      = Barney::VERSION
  s.authors      = ["Robert Gleeson"]
  s.email        = "rob@flowof.info"
  s.homepage     = "http://github.com/robgleeson/barney"
  s.summary      = "Barney tries to make the sharing of data between processes as easy and natural as possible."
  s.description  = s.summary

  s.files        = [ '.yardopts', 'README.md', 'ChangeLog', *Dir.glob("lib/**/**") ]
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'yard'
  s.add_development_dependency 'bluecloth' # for yard+markdown.
  s.add_development_dependency 'riot' 
end
