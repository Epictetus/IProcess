require 'barney/share' 

module Barney 

  VERSION = '0.9.1'

  @proxy = Barney::Share.new

  class << self

    def method_missing meth, *args, &blk
      if @proxy.respond_to? meth
        @proxy.send meth, *args, &blk
      else
        super
      end
    end

  end

end
