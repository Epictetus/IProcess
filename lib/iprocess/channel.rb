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
  # Add a object to the channel.
  #
  # @param [Object] object
  #   A object to add to the channel.
  #
  def put object
    @reader.close
    @writer.write Marshal.dump(object)
    @writer.close
  end

  #
  # Get a object from the channel.
  #
  # @return [Object]
  #   The object added to the channel.
  #
  def get
    @writer.close
    obj = Marshal.load(@reader.read)
    @reader.close
    obj
  end

end

