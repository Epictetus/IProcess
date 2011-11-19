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
    it 'should always unpollute the calling scope, even if an exception is raised in the passed block.' do
      begin 
        Barney do
          raise 
        end
      rescue
      end
      
      assert_equal false , instance_variable_defined?(:@__barney__)
      assert_equal Kernel, method(:fork).owner
      assert_raises(NameError) { method(:share).owner }
      assert_raises(NameError) { method(:unshare).owner }
    end

    it 'should be able to call methods in the calling scope.' do
      klass = MethodScopeTest.new
      klass.execute
      
      assert_equal true, klass.run
    end

    it 'should evaluate the passed block in the context it was created in.' do
      klass = SelfScopeTest.new
      klass.execute
      
      assert_equal "SelfScopeTest", klass.self 
    end
  end

end
