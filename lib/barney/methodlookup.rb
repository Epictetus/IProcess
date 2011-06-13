module Barney
  module MethodLookup

    METHODS = [ :share, :unshare, :fork ]

    class << self 
      def inject! &block
        target = block.binding.eval "self"
        target.instance_eval { extend Barney::MethodLookup }
      end

      def deject! &block
        target = block.binding.eval "self" 
        
        target.instance_eval do
          @__barney__ = nil
          (class << self; self; end).instance_eval do 
            METHODS.each { |method| undef_method(method) }
          end
        end
      end

      def extended object
        object.instance_eval { @__barney__ = Barney::Share.new }
      end
    end

    METHODS.each do |method|
      define_method method do |*args, &block|
        @__barney__.send method, *args, &block
      end

      define_method :fork do |*args, &block|
        @__barney__.send :fork, *args, &block
        @__barney__.sync
      end
    end

  end
end

