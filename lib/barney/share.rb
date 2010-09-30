module Barney

  class Share

    class << self
      # Serves as a temporary holder for the latest value read from the child process. 
      # @api    private   
      # @return [void]
      attr_accessor :value
    end

    # @return [Barney::Share] Returns an instance of Barney::Share.
    def initialize
      @shared        = []
      @communicators = nil
      @context       = nil
    end

    # The share method marks a variable or constant to be shared between two processes. 
    #  
    # @param  [Symbol]        Variable   Accepts a variable amount of Symbol objects.
    # @return [Array<Symbol>]            Returns a list of all variables that are being shared.
    def share(*variables)
      @shared = @shared | variables
    end

    # This method will spawn a new child process.  
    # It can be treated like the Kernel.fork method, but a block or Proc object is a 
    # required argument.
    # 
    # @param  [Proc]  Proc    Accepts a block or Proc object that will be executed in a child 
    #                         process.
    # 
    # @raise  [ArgumentError] It will raise an ArgumentError if a block or Proc object isn't 
    #                         supplied as an argument. 
    #                         
    # @return [Fixnum]        Returns the Process ID(PID) of the spawned child process.  
    def fork(&blk)
      raise(ArgumentError, "A block or Proc object is expected") unless block_given?

      @communicators = Array.new(@shared.size) { IO.pipe }  
      @context       = blk.binding
      process_id     = Kernel.fork do
        blk.call
        @communicators.each_with_index do |pipes, i|
          pipes[0].close  
          pipes[1].write(Marshal.dump(eval("#{@shared[i]}", @context)))
          pipes[1].close
        end
      end
      process_id
    end

    # This method synchronizes data between the parent and child process.  
    # This method will block until the spawned child process has exited. 
    # @return [void]
    def synchronize 
      @communicators.each_with_index do |pipes,i|
        pipes[1].close
        Barney::Share.value = Marshal.load(pipes[0].read)
        pipes[0].close
        eval("#{@shared[i]} = Barney::Share.value", @context)
      end
    end

  end

end


