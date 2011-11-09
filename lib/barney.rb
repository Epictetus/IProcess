module Barney 
end

require 'set'
require 'thread'
require 'barney/streampair'
require 'barney/process'
require 'barney/methodlookup'
require 'barney/core_ext/barney'
require 'barney/core_ext/jobs'
require 'barney/version'

# Ruby Enterprise Edition(REE).
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end
