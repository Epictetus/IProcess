module Barney

  module MethodLookup

    class << self 
      def inject! &block
        target = block.binding.eval "self"
        target.instance_eval { extend Barney::MethodLookup }
      end

      def deject! &block
        target = block.binding.eval "self" 
        target.instance_eval do
          Barney::Share.instance_methods(false).each do |meth|
            @__barney__ = nil
            (class << self; self; end).instance_eval { undef_method meth }
          end
        end
      end

      def extended object
        object.instance_eval do
          @__barney__ = Barney::Share.new
        end
      end
    end

    Barney::Share.instance_methods(false).each do |meth|
      define_method meth do |*args, &block|
        @__barney__.send meth, *args, &block
      end

      define_method :fork do |*args, &block|
        @__barney__.send :fork, *args, &block
        @__barney__.sync
      end
    end

  end

end

