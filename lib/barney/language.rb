module Barney::Language
  
  class << self
    def cleanup! scope
      if scope.instance_variable_defined? :@__barney__
        scope.send(:remove_instance_variable, :@__barney__)
      end
    end
  end

  #
  # @param *variables
  #   (see Barney::Process#share)
  #
  # @return 
  #   (see Barney::Process#share)
  #
  def share *variables 
    __barney__.share(*variables)
  end


  #
  # @param *variables
  #   (see Barney::Process#share)
  #
  # @return
  #   (see Barney::Process#unshare)
  #
  def unshare *variables
    __barney__.unshare(*variables)
  end
  
  #
  # Spawns a subprocess, and handles synchronization of shared variables.  
  # The status of the subprocess is also collected for you.
  #
  # @param &block
  #   (see Barney::Process#fork)
  #
  # @return 
  #   (see Barney::Process#fork)
  #
  def fork &block 
    __barney__.fork(&block)
    __barney__.wait_all
    __barney__.sync
  end

  def __barney__
    @__barney__ = @__barney__ || Barney::Process.new
  end
  private :__barney__

end
