module Barney::NaturalLanguage
  
  class << self
    def cleanup! scope
      if scope.instance_variable_defined? :@__barney__
        scope.send(:remove_instance_variable, :@__barney__)
      end
    end
  end

  def share *variables 
    __barney__.share(*variables)
  end

  def unshare *variables
    __barney__.unshare(*variables)
  end
        
  def fork &block 
    __barney__.fork(&block)
    __barney__.wait_all
    __barney__.sync
  end

  def __barney__
    @__barney__ = @__barney__ || Barney::Process.new
  end
end
