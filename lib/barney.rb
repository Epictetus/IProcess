require 'thread'
require 'barney/share'
require 'barney/emptystate'
require 'barney/core_ext'

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


