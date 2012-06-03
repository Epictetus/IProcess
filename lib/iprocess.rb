class IProcess
  require_relative 'iprocess/version'
  require_relative 'iprocess/channel'
  
  class << self
    #
    # @overload spawn(number_of = 1, worker)
    #
    #   Spawn one or more subprocesses.
    #
    #   @param [Integer] number_of
    #     The number of subprocesses to spawn.
    #
    #   @param [#call] worker
    #     The unit of work to execute in a subprocess.
    #
    #   @return [Array<Object>]
    #     The return value of the unit if worker.
    #
    def spawn(*args, &worker)
      fork(*args, &worker).map(&:result)
    end

    #
    # @overload
    #   
    #   Spawn one or more subprocesses asynchronously.
    #
    #   @param
    #     (see IProcess.spawn)
    #
    #   @return [Array<IProcess>]
    #     An array of IProcess objects. See {#defer}.
    #
    def spawn!(*args, &worker)
      fork *args, &worker
    end
  
    def fork(number_of = 1, obj = nil, &worker)
      worker = obj || worker

      Array.new(number_of) do
        IProcess.new(worker).tap { |job| job.execute }
      end
    end
    private :fork
  end

  #
  # @param [#call] worker
  #   The unit of work to execute in a subprocess.
  #
  # @raise [ArgumentError]
  #   If a worker is not given.
  #
  # @return [IProcess]
  #   Returns self.
  #
  def initialize(worker)
    @worker  = worker
    @channel = nil
    @pid     = nil

    unless @worker.respond_to?(:call)
      raise ArgumentError,
            "Expected worker to implement #{@worker.class}#call"
    end
  end

  #
  # @param [#recv] listener
  #   The listener.
  #
  # @return [void]
  #
  def defer(listener)
    Thread.new do
      Process.wait @pid
      listener.recv @channel.recv
    end
  end

  #
  # Executes a unit of work in a subprocess.
  #
  # @return [Fixnum]
  #   The process ID of the spawned subprocess.
  #
  def execute
    @channel = IProcess::Channel.new
    @pid = fork { @channel.write(@worker.call) }
  end

  #
  # @return [Object]
  #   Returns the return value of the unit of work.
  #
  def result
    Process.wait(@pid)
    @channel.recv
  end
end
