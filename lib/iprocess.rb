class IProcess

  #
  # @return [IProcess]
  #
  def initialize &block
    @variables = SortedSet.new
    @scope = nil

    if block_given?
      @scope = block.binding
      IProcess::Delegator.new(self).instance_eval(&block)
    end
  end

  #
  # @return [Array<Symbol>]
  #   Returns a list of shared variables.
  #
  def variables
    @variables.to_a
  end

  #
  # Marks a variable or constant to be shared between two processes.
  #
  # @param [Array<#to_sym>] variables
  #   Accepts the name(s) of the variables or constants to share.
  #
  # @return [Array<Symbol>]
  #   Returns a list of all variables that are being shared.
  #
  def share *variables
    @variables.merge variables.map(&:to_sym)
    @variables.to_a
  end

  #
  # Removes a variable or constant from being shared between two processes.
  #
  # @param [Array<#to_sym>] variables
  #   Accepts the name(s) of the variables or constants to stop sharing.
  #
  # @return [Array<Symbol>]
  #   Returns a list of the variables that are still being shared.
  #
  def unshare *variables
    @variables.subtract variables.map(&:to_sym)
    @variables.to_a
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

    scope = @scope || block.binding
    channels = @variables.map { |name| IProcess::Channel.new(name) }

    pid = Kernel.fork do
      scope.eval("self").instance_eval(&block)
      channels.each do |channel|
        channel.write scope.eval(channel.name.to_s)
      end
    end

    Process.wait(pid)

    channels.each do |channel|
      Thread.current[:__iprocess_obj__] = channel.recv
      scope.eval("#{channel.name} = Thread.current[:__iprocess_obj__]")
    end

    Thread.current[:__iprocess_obj__] = nil
    pid
  end

end

require 'set'
require 'iprocess/version'
require 'iprocess/channel'
require 'iprocess/job'
require 'iprocess/delegator'
