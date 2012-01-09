context IProcess::Job do
  context 'spawn' do
    it 'must spawn five workers and return the result of each.' do
      topic = IProcess::Job.spawn(5) { :ok }
      topic.must_equal([:ok, :ok, :ok, :ok, :ok])
    end
  end
end

