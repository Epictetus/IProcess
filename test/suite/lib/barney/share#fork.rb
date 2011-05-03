describe Barney::Share do
  
  describe '#fork' do

    it 'should return the Process ID(PID) on success.' do
      pid = Barney::Share.new.fork { }
      Process.wait pid
      assert_equal Fixnum, pid.class
    end

    it 'should raise an ArgumentError without a block or Proc.' do
      assert_raises ArgumentError do
        Barney::Share.new.fork
      end
    end

    it 'should not cause #history to return bad/incorrect data.' do
      50.times do 
        str = ""
        pids = []

        obj = Barney::Share.new
        obj.share :str

        %w(r u b y).each do |letter|
          pids << obj.fork do 
            str << letter
          end
        end

        pids.each { |pid| Process.wait pid }
        obj.sync

        str = obj.history.map(&:value).join
        assert_equal "ruby", str  
      end
    end
      
  end

end

