class Barney::Process

  attr_reader :variables
  attr_reader :history

  #
  # @yieldparam [Barney::Process] _self 
  #   Passes 'self' onto a block if given.
  #
  # @return [Barney::Process]
  #
  def initialize
    @streams   = []
    @history   = []
    @variables = SortedSet.new
    @scope     = nil

    if block_given?
      yield(self)
    end
  end

  #
  # Marks a variable or constant to be shared between two processes. 
  #
  # @param [Array<#to_sym>] variables  
  #   Accepts the name(s) of the variables or constants you want to share.
  #
  # @return [SortedSet<Symbol>] 
  #   Returns a list of all variables that are being shared.
  #
  def share *variables
    @variables.merge variables.map(&:to_sym)
  end

  #
  # Removes a variable or constant from being shared between two processes.
  #
  # @param [Array<#to_sym>] variables  
  #   Accepts the name(s) of the variables or constants you want to stop sharing.
  #
  # @return [SortedSet<Symbol>]             
  #   Returns a list of the variables that are still being shared.
  #
  def unshare *variables
    @variables.subtract variables.map(&:to_sym)
  end

  #
  # Collect the status of all subprocesses.
  #
  # @return [void]
  #
  def wait_all
    @history.each do |stream|
      begin
        Process.wait(stream.pid)
      rescue Errno::ECHILD
      end
    end
  end

  #
  # Spawns a child process.   
  #
  # @param [Proc] &block
  #   A Proc or block that will be executed in a child process.
  #
  # @raise [ArgumentError] 
  #   Raises an ArgumentError if a Proc or block is not given.
  #
  # @return [Fixnum] 
  #   Returns the Process ID(PID) of the spawned child process. 
  #
  def fork &block
    raise ArgumentError, "A block or Proc object is expected" unless block_given?
    @scope = block.binding

    streams = @variables.map do |name|
      Barney::StreamPair.new(name, *IO.pipe)
    end

    pid = Kernel.fork do
      block.call
      streams.each do |stream|
        stream.in.close  
        stream.out.write Marshal.dump(@scope.eval("#{stream.variable}"))
        stream.out.close
      end
    end
   
    streams.each do |stream|
      stream.pid = pid
    end

    @streams.push(*streams)
    pid
  end

  #
  # Synchronizes data between the parent and child process.  
  #
  # @return [void]
  #
  def synchronize 
    @streams.each do |stream|
      stream.out.close
      Thread.current[:BARNEYS_SERIALIZED_OBJECT] = Marshal.load stream.in.read
      stream.in.close
      stream.value = @scope.eval "#{stream.variable} = ::Thread.current[:BARNEYS_SERIALIZED_OBJECT]"
      @history.push(stream)
    end

    Thread.current[:BARNEYS_SERIALIZED_OBJECT] = nil
    @streams.clear
  end
  alias_method :sync, :synchronize

end

