require 'thread'
require 'barney/share' 

module Barney 

  VERSION = '0.12.0'
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
