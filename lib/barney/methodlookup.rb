module Barney
  module MethodLookup

    class << self 
      def inject! &block
        target = block.binding.eval "self"
        target.instance_eval { extend Barney::MethodLookup }
      end

      def deject! &block
        target    = block.binding.eval "self"
        singleton = block.binding.eval "class << self; self; end"  
        
        target.instance_eval { @__barney__ = nil }
        singleton.instance_eval do
          methods = Barney::MethodLookup.instance_methods false
          methods.each { |method| undef_method(method) }
        end
      end

      def extended object
        object.instance_eval { @__barney__ = Barney::Share.new }
      end
    end

    # @see Barney::Share#share
    def share *args
      @__barney__.share *args
    end

    # @see Barney::Share#unshare    
    def unshare *args
      @__barney__.unshare *args
    end

    # @see Barney::Share#fork
    def fork &block
      @__barney__.fork &block
      @__barney__.wait_all
      @__barney__.sync
    end

  end
end

