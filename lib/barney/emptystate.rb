module Barney

  class EmptyState
    attr_reader :__barney__
    
    Barney::Share.instance_methods(false).each do |meth|
      define_method meth do |*args, &block|
        @__barney__.send meth, *args, &block
      end

      undef_method :fork

      define_method :fork do |*args, &block|
        @__barney__.send :fork, *args, &block
        @__barney__.sync
      end
    end

    def initialize
      @__barney__ = Barney::Share.new
    end

  end

end

