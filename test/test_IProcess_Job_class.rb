context IProcess::Job do
  context 'spawn' do
    it 'must spawn two workers and return the result of each.' do
      topic = IProcess::Job.spawn(2) { :ok }
      topic.must_equal([:ok, :ok])
    end

    it 'must spawn non-Proc workers and return the result of each.' do
      worker = Class.new do
        def call
          :ok
        end
      end

      topic = IProcess::Job.spawn(2, worker.new)
      topic.must_equal([:ok, :ok])
    end

    it 'must accept any object responding to #call.' do
      mock = MiniTest::Mock.new
      mock.expect(:call, :ok)

      IProcess::Job.spawn(1, mock)
    end
  end

  context 'initialize' do
    it "must raise a ArgumentError if not given a object responding to #call" do
      proc { IProcess::Job.new("") }.must_raise(ArgumentError)
    end
  end
end

