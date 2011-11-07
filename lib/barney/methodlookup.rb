module Barney::MethodLookup

  class << self

    # Extends the "self" referenced by _block_ with a _share_, _unshare_, and _fork_ method.
    #
    # @api private
    # @param  [Proc]       Block
    # @raise  [NameError]  If @__barney__ is defined in the binding for _block_.
    # @return [void]
    def inject! &block
      module_eval do
        def share *variables 
          @__barney__.share(*variables)
        end

        def unshare *variables
          @__barney__.unshare(*variables)
        end
        
        def fork &block 
          @__barney__.fork(&block)
          @__barney__.wait_all
          @__barney__.sync
        end
      end

      target         = block.binding.eval "self"
      scope_polluted = target.instance_variable_defined? :@__barney__

      if scope_polluted
        raise NameError, "The instance variable @__barney__ has already been defined!\n" \
                         "Barney would like to use it, but it looks like you are using it for something else."
      else
        target.instance_variable_set :@__barney__, Barney::Process.new
        target.extend Barney::MethodLookup
      end
    end

    # Removes _share_, _unshare_, and _fork_ from the "self" referenced by _block_.   
    # Future method calls for _share_, _unshare_, and _fork_ will be made against "self", 
    # its superclasses, or modules it includes.
    # 
    # @api private
    # @param  [Proc] Block
    # @return [void]
    def deject! &block
      target = block.binding.eval "self"
      target.send :remove_instance_variable, :@__barney__ rescue nil

      remove_method :share
      remove_method :unshare
      remove_method :fork
    end
    
  end

end

