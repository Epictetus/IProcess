# Evaluates a block in the calling scope but provides access to the {Barney::Share#share}, 
# {Barney::Share#unshare}, and {Barney::Share#fork} methods.  
# Collecting the status of subprocesses and {Barney::Share#sync synchronization} is handled for you. 
#
# @example
#    
#   Barney do
#     name = "Robert"
#     share :name
#
#     fork do
#       name.slice! 3..5
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
  Barney::MethodLookup.inject! &block
  block.call
  Barney::MethodLookup.deject! &block 
end
