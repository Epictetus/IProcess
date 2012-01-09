class IProcess::Delegate

  #
  # @param [IProcess] delegate
  #   An instance of {IProcess}.
  #
  def initialize delegate
    @__delegate__ = delegate
  end

  #
  # @param
  #   (see IProcess#share)
  #
  # @return
  #   (see IProcess#share)
  #
  def share *args
    @__delegate__.share *args
  end

  #
  # @param
  #   (see IProcess#unshare)
  #
  # @return
  #   (see IProcess#unshare)
  #
  def unshare *args
    @__delegate__.unshare *args
  end

  #
  # @return
  #   (see IProcess#variables)
  #
  def variables
    @__delegate__.variables
  end

  #
  # @param
  #   (see IProcess#fork)
  #
  # @raise
  #   (see IProcess#fork)
  #
  # @return
  #   (see IProcess#fork)
  #
  def fork(&block)
    @__delegate__.fork(&block)
  end

end
