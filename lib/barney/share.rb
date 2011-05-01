module Barney

  class Share

    # @attr [Symbol] variable The name of the variable associated with _in_, and _out_.
    # @attr [IO]     in       The pipe which is used to read data.       
    # @attr [IO]     out      The pipe which is used to write data.
    # @api private
    StreamPair = Struct.new :variable, :in, :out

    # @attr [Symbol] variable The variable name.
    # @attr [Object] value    The value of the variable.
    HistoryItem = Struct.new :variable, :value

    @mutex = Mutex.new

    class << self
      # Returns the last value read from a spawned child process.
      # @api private
      # @return [Object]
      attr_accessor :value

      # Returns a Mutex that is used by the {Barney::Share#sync} method.
      # @api private
      # @return [Mutex] 
      attr_reader :mutex
    end

    # Returns a list of all variables or constants being shared for an instance of {Barney::Share}.
    # @return [Array<Symbol>] 
    attr_reader :variables

    # Returns the Process ID of the last forked process.
    # @return [Fixnum]
    attr_reader :pid

    # Returns an Array of {HistoryItem} objects.
    # @see HistoryItem
    # @return [Array<HistoryItem>]
    attr_reader :history
    
    # @yieldparam [Barney::Share] self Yields an instance of {Barney::Share}.
    # @return [Barney::Share]
    def initialize
      @streams   = []
      @variables = []
      @history   = []
      @context   = nil
      yield self if block_given? 
    end

    # Marks a variable or constant to be shared between two processes. 
    # @param  [Symbol, #to_sym]  Variable  Accepts the name(s) of the variables or constants you want to share.
    # @return [Array<Symbol>]              Returns a list of all variables that are being shared.
    def share *variables
      @variables.push *variables.map(&:to_sym)
      @variables.uniq!
      @variables
    end

    # Removes a variable or constant from being shared between two processes.
    # @param  [Symbol, #to_sym] Variable  Accepts the name(s) of the variables or constants you want to stop sharing.
    # @return [Array<Symbol>]             Returns a list of the variables that are still being shared.
    def unshare *variables
      variables.map(&:to_sym).each do |variable| 
        @streams.delete_if { |stream| stream.variable == variable }
        @variables.delete variable 
      end

      @variables
    end

    # Spawns a child process.  
    # It can be treated like the Kernel.fork method, but a block or Proc object is a required argument.
    # @param  [Proc]  Proc    Accepts a block or Proc object that will be executed in a child process.
    # @raise  [ArgumentError] Raises an ArgumentError if a block or Proc object isn't supplied.                        
    # @return [Fixnum]        Returns the Process ID(PID) of the spawned child process.  
    def fork &blk
      raise ArgumentError, "A block or Proc object is expected" unless block_given?

      @variables.each do |variable| 
        @streams.push StreamPair.new(variable, *IO.pipe)
      end
      
      @context = blk.binding
      @pid = Kernel.fork do
        blk.call
        @streams.each do |stream|
          stream.in.close  
          stream.out.write Marshal.dump(eval("#{stream.variable}", @context))
          stream.out.close
        end
      end

      @pid
    end

    # Synchronizes data between the parent and child process.  
    # It will block until the spawned child process has exited.
    # @return [void]
    def synchronize 
      Barney::Share.mutex.synchronize do
        @streams.each do |stream|
          stream.out.close
          Barney::Share.value = Marshal.load stream.in.read
          stream.in.close
          value = eval "#{stream.variable} = Barney::Share.value", @context 
          @history.push HistoryItem.new(stream.variable, value)
        end

        @streams.clear
      end 
    end
    alias_method :sync, :synchronize

  end

end


