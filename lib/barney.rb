require 'barney/share' 

module Barney 

  VERSION = '0.10.0'
  @proxy  = Barney::Share.new

  class << self

    def method_missing meth, *args, &blk
      if @proxy.respond_to? meth
        @proxy.send meth, *args, &blk
      else
        super
      end
    end

    def respond_to? meth, with_private = false
      super || @proxy.respond_to?(meth, with_private)
    end

  end

end
