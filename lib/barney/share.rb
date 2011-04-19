module Barney

  class Share

    # @attr [IO] in      The pipe which is used to read data.       
    # @attr [IO] out     The pipe which is used to write data.
    # @api private
    StreamPair = Struct.new :in, :out

    # @attr [Symbol] variable The variable name.
    # @attr [Object] value    The value of the variable.
    HistoryItem = Struct.new :variable, :value

    @mutex = Mutex.new

    class << self
      # Returns the latest value read from a spawned child process. 
      # @api private
      # @return [Object]
      attr_accessor :value

      # Returns a Mutex that is used when {Barney::Share.value Barney::Share.value} is being accessed by {Barney::Share#synchronize}
      # @api private
      # @return [Mutex] 
      attr_reader :mutex
    end

    # Returns a list of all variables or constants being shared for this instance of {Barney::Share Barney::Share}.
    # @return [Array<Symbol>] 
    attr_reader :variables

    # Returns the Process ID of the last forked process.
    # @return [Fixnum]
    attr_reader :pid

    # @return [Array<HistoryItem>]
    attr_reader :history
    
    # @yieldparam [Barney::Share] self Yields an instance of {Barney::Share}.
    # @return [Barney::Share]
    def initialize
      @shared    = Hash.new { |h,k| h[k] = [] }
      @variables = []
      @history   = []
      @context   = nil
      yield self if block_given? 
    end

    # Serves as a method to mark a variable or constant to be shared between two processes. 
    # @param  [Symbol] Variable   Accepts a variable amount of Symbol objects.
    # @return [Array<Symbol>]     Returns a list of all variables that are being shared.
    def share *variables
      @variables.push *variables.map(&:to_sym)
      @variables.uniq!
    end

    # Serves as a method to remove a variable or constant from being shared between two processes.
    # @param  [Symbol] Variable Accepts a variable amount of Symbol objects.
    # @return [Array<Symbol>]   Returns a list of the variables that are still being shared.
    def unshare *variables
      variables.map(&:to_sym).each { |variable| @variables.delete variable }
      @variables
    end

    # Serves as a method to spawn a new child process.  
    # It can be treated like the Kernel.fork method, but a block or Proc object is a required argument.
    # @param  [Proc]  Proc    Accepts a block or Proc object that will be executed in a child 
    #                         process.
    # 
    # @raise  [ArgumentError] It will raise an ArgumentError if a block or Proc object isn't 
    #                         supplied as an argument. 
    #                         
    # @return [Fixnum]        Returns the Process ID(PID) of the spawned child process.  
    def fork &blk
      raise ArgumentError, "A block or Proc object is expected" unless block_given?
      spawn_pipes

      @context = blk.binding
      @pid     = Kernel.fork do
        blk.call
        @shared.each do |variable, history|
          stream = history[-1]
          stream.in.close  
          stream.out.write Marshal.dump(eval("#{variable}", @context))
          stream.out.close
        end
      end

      @pid
    end

    # Serves as a method that synchronizes data between the parent and child process.  
    # It will block until the spawned child process has exited. 
    # @return [void]
    def synchronize 
      Barney::Share.mutex.synchronize do
        @shared.each do |variable, history|
          history.each do |stream|
            stream.out.close
            Barney::Share.value = Marshal.load stream.in.read
            stream.in.close
            value = eval "#{variable} = Barney::Share.value", @context 
            @history.push HistoryItem.new variable, value
          end
        end
      end
    end
    alias_method :sync, :synchronize

    private

    def spawn_pipes
      @shared.keep_if do |variable|
        @variables.member? variable
      end

      @variables.each do |variable|
        @shared[variable].push StreamPair.new *IO.pipe
      end
    end

  end

end


