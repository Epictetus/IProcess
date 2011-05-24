# Returns an Array populated by the return value of the block.  
# Each block is executed in a subprocess.
#
# @param  [Proc]   Block      The block to execute in a subprocess. 
# @param  [Fixnum] Processes  The number of subprocesses to spawn.
# @return [Array<Object>] 
def Jobs number, &block
  barney = Barney::Share.new
  barney.share :queue
  queue = []

  number.times do
    barney.fork do
      queue << block.call
    end
  end

  barney.wait_all
  barney.sync

  barney.history.map(&:value).flatten
end
 
