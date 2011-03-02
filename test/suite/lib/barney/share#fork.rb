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
    
  end
end

