module Barney

  class Share

    def initialize
      @shared = []
    end

    # @param [Array<Symbol>]
    def share(var)
      @shared << var  
    end

    def fork(&blk)
      pipes = []
      @shared.size.times { pipes << IO.pipe }
      binding     = blk.binding
      process_id  = Kernel.fork do
        blk.call
        pipes.each_with_index do |arr, i|
          arr[0].close  
          arr[1].write(Marshal.dump(eval("#{@shared[i]}", binding)))
          arr[1].close
        end
      end

      pipes.each_with_index do |arr,i|
        arr[1].close
        Barney.value_from_child = Marshal.load(arr[0].read)
        arr[0].close
        eval("#{@shared[i]} = Barney.value_from_child", binding)
      end
      process_id
    end

  end

end


