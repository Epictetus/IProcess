# Evaluates a block in the calling scope but provides access to the {Barney::Process#share}, 
# {Barney::Process#unshare}, and {Barney::Process#fork} methods.  
# Collecting the status of subprocesses and {Barney::Process#sync synchronization} is handled for you. 
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
# @raise [NameError]     If @__barney__ is defined in the binding for _block_.
# @return [void]
def Barney &block
  raise ArgumentError, "Block expected" unless block_given?
  
  Mixit.temporarily(Barney::NaturalLanguage, block) do 
    block.call
  end
end
