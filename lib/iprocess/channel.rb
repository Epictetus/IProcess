class IProcess::Channel

  #
  # @yieldparam [IProcess::Channel] _self
  #   Yields self.
  #
  def initialize
    @reader, @writer = IO.pipe

    if block_given?
      yield self
    end
  end

  #
  # Is the channel closed?
  #
  # @return [Boolean]
  #   Returns true if the channel is closed.
  #
  def closed?
    @reader.closed? && @writer.closed?
  end

  #
  # Is the channel open?
  #
  # @return [Boolean]
  #   Returns true if the channel is open.
  #
  def open?
    !closed?
  end

  #
  # Write a object to the channel.
  #
  # @param [Object] object
  #   A object to add to the channel.
  #
  def write object
    if open?
      @reader.close
      @writer.write Marshal.dump(object)
      @writer.close
    end
  end

  #
  # Receive a object from the channel.
  #
  # @return [Object]
  #   The object added to the channel.
  #
  def recv
    if open?
      @writer.close
      obj = Marshal.load(@reader.read)
      @reader.close
      obj
    end
  end

end
