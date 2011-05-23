require 'thread'
require 'barney/share' 
require 'barney/emptystate'

module Barney 

  VERSION = '0.14.0'
  @proxy  = Barney::Share.new

  class << self

    # Forward message to an instance of {Barney::Share Barney::Share}.
    #
    # @see Barney::Share Barney::Share.
    def method_missing meth, *args, &blk
      if @proxy.respond_to? meth
        @proxy.send meth, *args, &blk
      else
        super
      end
    end

    # Ask {Barney} does it respond to _meth_.
    #
    # @param  [String, Symbol, #to_sym] Name  The method name.
    # @param  [Boolean]                 Scope Pass true to extend scope to include private methods.
    # @return [Boolean]                       Return true if {Barney} can respond to _meth_.
    def respond_to? meth, with_private = false
      super || @proxy.respond_to?(meth, with_private)
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
