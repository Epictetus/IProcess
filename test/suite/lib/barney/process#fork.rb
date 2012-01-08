describe IProcess::Process do

  describe '#fork' do

    it 'should return the Process ID(PID) on success.' do
      pid = IProcess::Process.new.fork { }
      Process.wait pid
      assert_equal Fixnum, pid.class
    end

    it 'should raise an ArgumentError without a block or Proc.' do
      assert_raises ArgumentError do
        IProcess::Process.new.fork
      end
    end

    it 'should not cause #history to return bad/incorrect data.' do
      50.times do
        str = ""
        pids = []

        obj = IProcess::Process.new
        obj.share :str

        %w(r u b y).each do |letter|
          obj.fork do
            str << letter
          end
        end

        obj.wait_all
        obj.sync

        str = obj.history.map(&:value).join
        assert_equal "ruby", str
      end
    end

  end

end

