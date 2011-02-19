module Barney

  class Share

    @mutex = Mutex.new

    class << self
      # Serves as a temporary holder for the latest value read from the child process.
      # @api private
      # @return [Object] Returns Object or subclass of.
      attr_accessor :value

      # Serves as a lock when {Barney::Share.value Barney::Share.value} is being accessed by {Barney::Share#synchronize}
      # @api private
      # @return [Mutex] 
      attr_reader :mutex
    end

    # Returns a list of all variables or constants being shared for this instance of {Barney::Share Barney::Share}.
    # @return [Array<Symbol>] 
    attr_reader :shared
    def shared; @shared.keys; end
  
    # Serves as a method that tells you the Process ID of the last forked child process.
    # @return [Fixnum] Returns the Process ID as a Fixnum.
    attr_reader :pid

    # Serves as a method to provide a history of changes made in multiple forks for a single instance of {Barney::Share}.
    # @return [{ Fixnum => { Symbol => Object }}] Fixnum represents sequence, Symbol the variable, and Object its value. 
    attr_reader :history
    
    # @return [Barney::Share] Returns an instance of Barney::Share.
    def initialize
      @shared  = Hash.new
      @context = nil
      @history = {}
      @seq     = 0
    end

    # Serves as a method to mark a variable or constant to be shared between two processes. 
    # @param  [Symbol] Variable   Accepts a variable amount of Symbol objects.
    # @return [Array<Symbol>]     Returns a list of all variables that are being shared.
    def share *variables
      variables.map(&:to_sym).each do |variable|
        @shared.store variable, (@shared[variable] || {}).merge({ @seq => IO.pipe })
      end
      @shared.keys
    end

    # Serves as a method to remove a variable or constant from being shared between two processes.
    # @param  [Symbol] Variable Accepts a variable amount of Symbol objects.
    # @return [Array<Symbol>]   Returns a list of the variables that are still being shared.
    def unshare *variables
      variables.map(&:to_sym).each do |variable|
        @shared.delete variable
      end
      @shared.keys
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

      share *@shared.keys if @pid

      @context = blk.binding
      @pid     = Kernel.fork do
        blk.call
        @shared.each do |variable, hash|
          hash[@seq][0].close  
          hash[@seq][1].write Marshal.dump(eval("#{variable}", @context))
          hash[@seq][1].close
        end
      end
      
      @seq += 1
      @pid
    end

    # Serves as a method that synchronizes data between the parent and child process.  
    # It will block until the spawned child process has exited. 
    # @return [void]
    def synchronize 
      @shared.each do |variable, hash|
        Barney::Share.mutex.synchronize do
          0.upto(@seq-1) do |seq|
           unless hash[seq][0].closed? || hash[seq][1].closed?
              hash[seq][1].close
              Barney::Share.value = Marshal.load hash[seq][0].read
              hash[seq][0].close
              object = eval "#{variable} = Barney::Share.value", @context 
              @history[seq] = { variable => object }
            end
          end
        end
      end
    end
    alias_method :sync, :synchronize

  end

end


