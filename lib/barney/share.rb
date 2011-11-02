require 'set'

class Barney::Share

  #
  # @attr [Symbol] variable 
  #   The name of the variable associated with _in_, and _out_.
  #
  # @attr [IO] in       
  #   The pipe which is used to read data.  
  #
  # @attr [IO] out      
  #   The pipe which is used to write data.
  # 
  # @api private
  # 
  StreamPair = Struct.new :variable, :in, :out

  #
  # @attr [Symbol] variable 
  #   The variable name.
  #
  # @attr [Object] value    
  #   The value of the variable.
  #
  HistoryItem = Struct.new :variable, :value

  #
  # @return [SortedSet<Symbol>] 
  #   A list of variables being shared for a instance of {Barney::Share}.
  #
  attr_reader :variables

  #
  # @return [Fixnum]
  #   The Process ID of the last forked process.
  #
  attr_reader :pid

  #
  # @see HistoryItem
  #
  # @return [Array<HistoryItem>]
  #   An Array of {HistoryItem} objects.
  #
  attr_reader :history
 
  #
  # @yieldparam [Barney::Share] _self 
  #   An instance of {Barney::Share}.
  #
  def initialize
    @streams   = []
    @variables = SortedSet.new
    @history   = []
    @pids      = []
    @pid       = nil
    @scope     = nil
    yield self if block_given? 
  end

  #
  # Marks a variable or constant to be shared between two processes. 
  #
  # @param [#to_sym] variables  
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
  # @param [#to_sym] variables  
  #   Accepts the name(s) of the variables or constants you want to stop sharing.
  #
  # @return [SortedSet<Symbol>]             
  #   Returns a list of the variables that are still being shared.
  #
  def unshare *variables
    variables.each do |variable| 
      @variables.delete(variable.to_sym) 
    end

    @variables
  end

  #
  # Collect the status of all subprocesses spawned by a {Barney::Share Barney::Share} instance.
  #
  # @return [void]
  #
  def wait_all
    @pids.each do |pid| 
      Process.wait(pid)
    end

    @pids.clear
  end

  #
  # Spawns a child process.  
  # It can be treated like the Kernel.fork method, but a block or Proc object is a required argument.
  # 
  # @param [Proc] &block
  #   A block or Proc object that will be executed in a child process.
  #
  # @raise [ArgumentError] 
  #   Raises an ArgumentError if a block or Proc object isn't supplied. 
  #
  # @return [Fixnum]        
  #   Returns the Process ID(PID) of the spawned child process. 
  #
  def fork &block
    raise ArgumentError, "A block or Proc object is expected" unless block_given?
    @scope = block.binding

    streams = @variables.map do |name|
      StreamPair.new(name, *IO.pipe)
    end

    @pid = Kernel.fork do
      block.call
      streams.each do |stream|
        stream.in.close  
        stream.out.write Marshal.dump(@scope.eval("#{stream.variable}"))
        stream.out.close
      end
    end
    
    @streams.push(*streams)
    @pids.push @pid
    @pid
  end

  #
  # Synchronizes data between the parent and child process.  
  #
  # @return [void]
  #
  def synchronize 
    @streams.each do |stream|
      stream.out.close
      Thread.current[:BARNEY_SERIALIZED_OBJECT] = Marshal.load stream.in.read
      stream.in.close
      value = @scope.eval "#{stream.variable} = ::Thread.current[:BARNEY_SERIALIZED_OBJECT]"
      @history.push HistoryItem.new(stream.variable, value)
    end

    Thread.current[:BARNEY_SERIALIZED_OBJECT] = nil
    @streams.clear
  end
  alias_method :sync, :synchronize

end


