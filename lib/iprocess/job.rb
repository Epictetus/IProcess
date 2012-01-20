class IProcess::Job

  #
  # @overload spawn(number_of_jobs, worker)
  #
  #   Spawn one or more jobs to be run in parallel.
  #
  #   @param [Integer] number_of_jobs
  #     The number of jobs to spawn.
  #
  #   @param [#call] worker
  #     The unit of work to execute in one or more jobs.
  #
  #   @return [Array<Object>]
  #     The return value of one or more workers.
  #
  def self.spawn number_of_jobs = 1, obj = nil, &worker
    worker = obj || worker

    jobs =
    Array.new(number_of_jobs) do
      job = IProcess::Job.new(worker)
      job.execute
      job
    end

    jobs.map do |job|
      job.result
    end
  end

  #
  # @param [#call] worker
  #   The unit of work to execute in a subprocess.
  #
  # @raise [ArgumentError]
  #   If a worker is not given.
  #
  # @return [IProcess::Job]
  #   Returns self.
  #
  def initialize worker
    @worker  = worker
    @channel = nil
    @pid     = nil

    unless @worker.respond_to?(:call)
      raise ArgumentError,
            "Expected worker to implement #{@worker.class}#call"
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


