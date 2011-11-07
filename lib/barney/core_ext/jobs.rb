# Runs a block in one or more subprocesses, returning the return value of the block everytime it is executed. 
#
# @example
#   results = Jobs(5) { 42 }
#   p results # [42, 42, 42, 42, 42]
#
# @param  [Proc]   Block      The block to execute in a subprocess. 
# @param  [Fixnum] Processes  The number of subprocesses to spawn.
# @raise  [ArgumentError]     If no block is supplied.
# @return [Array<Object>] 
def Jobs processes
  raise ArgumentError, 'Block expected' unless block_given?

  barney = Barney::Process.new
  barney.share :queue
  queue = []

  processes.times do
    barney.fork do
      queue.push yield 
    end
  end

  barney.wait_all
  barney.sync

  barney.history.map(&:value).flatten 1
end
