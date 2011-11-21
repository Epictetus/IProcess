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
  #   Accepts the name(s) of the variables or constants to share.
  #
  # @return [SortedSet<Symbol>] 
  #   Returns a list of all variables that are being shared.
  #
  def share *variables
    @variables.merge variables.map { |var|
      Barney::Symbol.new(var)
    }
  end

  #
  # Removes a variable or constant from being shared between two processes.
  #
  # @param [Array<#to_sym>] variables  
  #   Accepts the name(s) of the variables or constants to stop sharing.
  #
  # @return [SortedSet<Symbol>]             
  #   Returns a list of the variables that are still being shared.
  #
  def unshare *variables
    @variables.subtract variables.map { |var|
      Barney::Symbol.new(var)
    }
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
    unless block_given?
      raise ArgumentError, "A block or Proc object is expected" 
    end

    @scope = block.binding

    streams = @variables.map do |name|
      Barney::StreamPair.new(name, *IO.pipe)
    end

    pid = Kernel.fork do
      block.call
      streams.each do |stream|
        stream.input.close  
        stream.output.write Marshal.dump(@scope.eval("#{stream.variable}"))
        stream.output.close
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
      expr = "#{stream.variable} = ::Thread.current[:__barney__]"
      
      stream.output.close
      Thread.current[:__barney__] = Marshal.load(stream.input.read)
      stream.input.close
      stream.value = @scope.eval(expr)   
      
      @history.push(stream)
    end

    Thread.current[:__barney__] = nil
    @streams.clear
  end
  alias_method :sync, :synchronize

end


