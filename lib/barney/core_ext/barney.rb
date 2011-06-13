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
