context IProcess::Job do
  context 'spawn' do
    it 'must spawn two workers and return the result of each.' do
      topic = IProcess::Job.spawn(2) { :ok }
      topic.must_equal([:ok, :ok])
    end
  end
end

