#
# @yieldparam [IProcess::Process]
#   Yields {IProcess::Process}.
#
# @raise [ArgumentError]
#   If no block is supplied.
#
# @return [void]
#
def IProcess &block
  unless block_given?
    raise ArgumentError, "No block given."
  end

  yield IProcess::Process.new
end
