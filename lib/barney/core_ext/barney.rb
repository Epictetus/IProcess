#
# @example   
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
# @raise [ArgumentError] 
#   If no block is supplied.
#
# @return [void]
#
def Barney &block
  raise ArgumentError, "Block expected" unless block_given?
 
  if block.arity != 0
    Mixit.temporarily Barney::NaturalLanguage, :scope => block do 
      block.call
    end
  else
    yield Barney::Process.new
  end
end
