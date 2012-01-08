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
  # Write a object to the channel.
  #
  # @param [Object] object
  #   A object to add to the channel.
  #
  def write object
    @reader.close
    @writer.write Marshal.dump(object)
    @writer.close
  end

  #
  # Receive a object from the channel.
  #
  # @return [Object]
  #   The object added to the channel.
  #
  def recv
    @writer.close
    obj = Marshal.load(@reader.read)
    @reader.close
    obj
  end

end

