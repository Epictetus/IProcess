class IProcess::Delegate

  def initialize delegate
    @__delegate__ = delegate
  end

  def share *args
    @__delegate__.share *args
  end

  def unshare *args
    @__delegate__.unshare *args
  end

  def fork(&block)
    @__delegate__.fork(&block)
  end

end
