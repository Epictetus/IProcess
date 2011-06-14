module Barney
  module MethodLookup

    class << self
      
      # Injects the instance methods of {Barney::MethodLookup} on the "self" referenced by _block_.
      #
      # @api private
      # @param  [Proc] Block
      # @return [void]
      def inject! &block
        target = block.binding.eval "self"
        target.instance_eval { @__barney__ = Barney::Share.new }
        target.instance_eval { extend Barney::MethodLookup }
      end

      # Dejects(removes) the instance methods of {Barney::MethodLookup} on the "self" referenced by _block_.
      #
      # @api private
      # @param  [Proc] Block
      # @return [void]
      def deject! &block
        target    = block.binding.eval "self"
        singleton = block.binding.eval "class << self; self; end"  
        methods   = Barney::MethodLookup.instance_methods false

        target.instance_eval { @__barney__ = nil }
        singleton.instance_eval do
          methods.each { |method| undef_method(method) }
        end
      end
    end

    # @api private
    # @see Barney::Share#share
    def share *args
      @__barney__.share *args
    end

    # @api private
    # @see Barney::Share#unshare    
    def unshare *args
      @__barney__.unshare *args
    end

    # @api private
    # @see Barney::Share#fork
    def fork &block
      @__barney__.fork &block
      @__barney__.wait_all
      @__barney__.sync
    end

  end
end

