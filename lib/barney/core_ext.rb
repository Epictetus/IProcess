# Evaluates a block with access to all the methods available to a {Barney::Share Barney::Share} instance.  
# Collecting the status of subprocesses and {Barney::Share#sync synchronization} is handled for you. 
#
# @example
#    
#   Barney do
#     name = "Robert"
#     share :name
#
#     fork do
#       name.slice! 0..2
#     end
#
#     p name # "Rob"
#   end
#
#
# @raise [ArgumentError] If no block is supplied.
# @return [void]
def Barney &block
  raise ArgumentError, "Block expected" unless block_given?
  emptystate = Barney::EmptyState.new
  emptystate.instance_eval &block
  emptystate.__barney__.wait_all 
end

# Runs _block_ in one or more subprocesses, returning the return value of each block in an Array.
#
# @example
#   results = Jobs(5) { 42 }
#   p results # [42, 42, 42, 42, 42]
#
# @param  [Proc]   Block      The block to execute in a subprocess. 
# @param  [Fixnum] Processes  The number of subprocesses to spawn.
# @raise  [ArgumentError]     If no block is supplied.
# @return [Array<Object>] 
def Jobs number, &block
  raise ArgumentError, 'Block expected' unless block_given?

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
 
