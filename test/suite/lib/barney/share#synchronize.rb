describe Barney::Share do
  describe '#sync' do
    
    before do 
      @object = Barney::Share.new
    end

    it 'should confirm a variable can be synced.' do
      a = 5
      @object.share :a
      pid = @object.fork { a = 6 }
      Process.wait pid
      @object.sync 
      assert_equal 6, a
    end

    it 'should confirm a variable can  be synced after mutation' do  
      a = 'abc'
      @object.share :a
      pid = @object.fork { a.sub! 'a','b' }
      Process.wait pid
      @object.sync
      assert_equal 'bbc', a
    end

    it 'should confirm two variables can be synced.' do      
      a,b = 10,20
      @object.share :a,:b
      pid = @object.fork { a,b = 4,5 }
      Process.wait pid
      @object.sync

      assert_equal 4, a
      assert_equal 5, b
    end

    it 'should fix Github Issue #1' do
      $times  = 2
      @object.share :$times

      pid = @object.fork  { $times = 4 }
      pid2 = @object.fork { $times = 5 }
      pid3 = @object.fork { $times = 6 }

      Process.wait pid
      Process.wait pid2
      Process.wait pid3
      @object.sync

      assert_equal 6, $times
    end

    it 'should fix Github Issue #2' do
      a,b = 4,5
      @object.share :a
      @object.fork { }
      Process.wait @object.pid
      @object.share :b 
      @object.fork { b = 6 }
      @object.sync # will raise NoMethodError if fails. 
    end

    it 'should fix GitHub Issue #3' do
      a,b = 4,5
      @object.share :a, :b
      @object.fork { }
      Process.wait @object.pid
      @object.sync
      assert_equal({ 0 => { :a => 4, :b => 5 } }, @object.history)
    end

  end
end
  
