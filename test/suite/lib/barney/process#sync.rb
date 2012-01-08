describe IProcess::Process do

  describe '#sync' do

    before do
      @instance = IProcess::Process.new
    end

    it 'should assert a variable can be synced.' do
      x = 5

      @instance.share :x
      pid = @instance.fork do
        x = 6
      end
      Process.wait pid
      @instance.sync

      assert_equal 6, x
    end

    it 'should assert a variable can  be synced after mutation' do
      message = 'foo'

      @instance.share :message
      pid = @instance.fork { message.sub! 'foo','bar' }
      Process.wait pid
      @instance.sync

      assert_equal 'bar', message
    end

    it 'should assert two variables can be synced.' do
      x = 10
      y = 20

      @instance.share :x, :y
      pid = @instance.fork do
        x -= 1
        y -= 1
      end
      Process.wait pid
      @instance.sync

      assert_equal 9 , x
      assert_equal 19, y
    end

    it 'should fix Github Issue #1' do
      $times  = 2
      @instance.share :$times

      pid  = @instance.fork { $times = 4 }
      pid2 = @instance.fork { $times = 5 }
      pid3 = @instance.fork { $times = 6 }

      Process.wait pid
      Process.wait pid2
      Process.wait pid3
      @instance.sync

      assert_equal 6, $times
    end

    it 'should fix Github Issue #2' do
      x = 4
      y = 5

      @instance.share :x
      @instance.fork { }
      @instance.wait_all

      @instance.share :y
      @instance.fork { b = 6 }
      @instance.wait_all

      @instance.sync # will raise NoMethodError if fails.
    end

    it 'should fix GitHub Issue #3' do
      x = 4
      y = 5

      @instance.share :x, :y
      @instance.fork { }
      @instance.wait_all
      @instance.sync

      assert_equal 4, @instance.history[0].value
      assert_equal 5, @instance.history[1].value
    end

    it 'should assert a IOError (Closed Stream) is not raised.' do
      x = 5
      pids = []
      @instance.share :x
      pids << @instance.fork { }
      @instance.sync
      pids << @instance.fork { }
      pids.each { |pid| Process.wait pid }
    end

  end

end

