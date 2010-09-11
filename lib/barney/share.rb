module Barney

  class Share

    # @return [Barney::Share] Returns an instance of Barney::Share.
    def initialize
      @shared        = []
      @communicators = nil
      @context       = nil
    end

    # @param  [Array<Symbol>] Accepts an Array of Symbol objects. 
    # @return [Array]         Returns an Array object.
    def share(var)
      @shared << var  
    end

    # @param  [Proc]          Accepts a block or Proc object.
    # @return [Fixnum]        Returns the Process ID(PID) of the spawned child process.  
    def fork(&blk)
      raise(ArgumentError, "A block or Proc object is expected") unless block_given?

      @communicators = Array.new(@shared.size) { IO.pipe }  
      @context       = blk.binding
      process_id     = Kernel.fork do
        blk.call
        @communicators.each_with_index do |pipes, i|
          pipes[0].close  
          pipes[1].write(Marshal.dump(eval("#{@shared[i]}", binding)))
          pipes[1].close
        end
      end
      process_id
    end

    def synchronize 
      @communicators.each_with_index do |pipes,i|
        pipes[1].close
        Barney.value_from_child = Marshal.load(pipes[0].read)
        pipes[0].close
        eval("#{@shared[i]} = Barney.value_from_child", @context)
      end
    end

  end

end


