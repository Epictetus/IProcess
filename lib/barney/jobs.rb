# Returns an Array populated by the return value of a block.  
# Each block is executed in a subprocess.
#
# @example
#   results = Jobs(5) { 42 }
#   p results # [42, 42, 42, 42, 42]
#
# @param  [Proc]   Block      The block to execute in a subprocess. 
# @param  [Fixnum] Processes  The number of subprocesses to spawn.
# @raise  [ArgumentError]     If block is missing.
# @return [Array<Object>] 
def Jobs number, &block
  raise ArgumentError, 'block expected' unless block_given?

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
 
