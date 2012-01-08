class IProcess

  #
  # @yieldparam [IProcess::Process] _self
  #   Passes 'self' onto a block if given.
  #
  # @return [IProcess::Process]
  #
  def initialize
    @variables = SortedSet.new
    @scope     = nil

    if block_given?
      yield(self)
    end
  end

  #
  # Marks a variable or constant to be shared between two processes.
  #
  # @param [Array<#to_sym>] variables
  #   Accepts the name(s) of the variables or constants to share.
  #
  # @return [SortedSet<IProcess::Symbol>]
  #   Returns a list of all variables that are being shared.
  #
  def share *variables
    @variables.merge variables.map(&:to_sym)
  end

  #
  # Removes a variable or constant from being shared between two processes.
  #
  # @param [Array<#to_sym>] variables
  #   Accepts the name(s) of the variables or constants to stop sharing.
  #
  # @return [SortedSet<IProcess::Symbol>]
  #   Returns a list of the variables that are still being shared.
  #
  def unshare *variables
    @variables.subtract variables.map(&:to_sym)
  end

  #
  # Spawns a subprocess.
  # The subprocess is waited on via Process.wait().
  #
  # @param [Proc] &block
  #   A block executed within a subprocess.
  #
  # @raise [ArgumentError]
  #   If no block is given.
  #
  # @return [Fixnum]
  #   The Process ID(PID) of the subprocess.
  #
  def fork &block
    unless block_given?
      raise ArgumentError, "No block given."
    end

    @scope = block.binding

    channels = @variables.map {
      IProcess::Channel.new
    }

    pid = Kernel.fork do
      block.call
      @variables.each.with_index do |name, i|
        channels[i].put @scope.eval("#{name}")
      end
    end

    Process.wait(pid)

    @variables.each.with_index do |name, i|
      Thread.current[:__iprocess_obj__] = channels[i].get
      @scope.eval("#{name} = Thread.current[:__iprocess_obj__]")
    end

    pid
  end

end

require 'set'
require 'iprocess/channel'
require 'iprocess/version'
