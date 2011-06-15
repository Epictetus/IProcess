describe '#Barney' do

  describe 'synchronization' do
    before do
      @name = nil
    end

    it 'should synchronize a local variable.' do
      name = 'Robert'

      Barney do
        share :name
        fork { name.slice! 3..5}
        fork { name.slice! 1..2 }
      end

      assert_equal "R", name
    end

    it 'should synchronize an instance variable.' do
      @name = 'Robert'

      Barney do
        share :@name
        fork { @name.slice! 3..5 }
        fork { @name.slice! 1..2 }
      end

      assert_equal "R", @name
    end
  end

  describe 'scope' do
    it 'should be able to call methods in the calling scope.' do
      klass = MethodScopeTest.new
      klass.execute
      
      assert_equal true, klass.run
    end

    it 'should evaluate the passed block in the context it is created in.' do
      klass = SelfScopeTest.new
      klass.execute
      
      assert_equal "SelfScopeTest", klass.self 
    end

    it 'should inject and then deject #share, #unshare and #fork on the calling self.' do
      Barney do
        assert_equal "#Barney::scope"    , self.class.to_s
        assert_equal Barney::MethodLookup, method(:share).owner
        assert_equal Barney::MethodLookup, method(:unshare).owner
        assert_equal Barney::MethodLookup, method(:fork).owner
      end

      assert_equal "#Barney::scope", self.class.to_s
      assert_raises(NameError) { method(:share) }
      assert_raises(NameError) { method(:unshare) }
      assert_equal Kernel, method(:fork).owner
    end
  end

end
