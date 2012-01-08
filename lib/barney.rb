module Barney
end

require 'set'
require 'mixit'
require 'barney/streampair'
require 'barney/process'
require 'barney/language'
require 'barney/core_ext/barney'
require 'barney/core_ext/jobs'
require 'barney/version'

#
# Ruby Enterprise Edition (REE) only.
# Enable CoW-friendly garbage collection.
#
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end
