require 'thread'
require 'barney/share'
require 'barney/jobs'
require 'barney/emptystate'

module Barney 

  VERSION = '0.15.1'
  @proxy  = Barney::Share.new

  class << self

    Barney::Share.instance_methods(false).each do |method|
      define_method method do |*args, &block|
        $stderr.puts "[WARNING] Barney.#{method} is deprecated and will be removed in the next release."
        @proxy.send method, *args, &block
      end
    end

  end

end

# Evaluates a block with access to all the methods available to a {Barney::Share Barney::Share} instance.  
# Collecting the status of subprocesses and {Barney::Share#sync synchronization} is handled for you. 
#
# @example
#     name = "Robert"
#     
#     Barney do
#       share :name
#
#       fork do
#         name.slice! 0..2
#       end
#     end
#
#     p name # "Rob"
#
# @raise [ArgumentError] If no block is supplied.
# @return [void]
def Barney &block
  raise ArgumentError, "Block expected" unless block_given?
  emptystate = Barney::EmptyState.new
  emptystate.instance_eval &block
  emptystate.__barney__.wait_all 
end
