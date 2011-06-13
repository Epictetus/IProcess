describe '#Barney' do

  before do
    @foo = nil
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
    @foo = 'bar'

    Barney do
      share :@foo
      fork { @foo = "baz" }
    end

    assert_equal "baz", @foo
  end

  it 'should evaluate the passed block in the context it is created in' do
    klass = nil

    Barney do
      share :klass
      fork { klass = self.class.to_s }
    end

    assert_equal klass, self.class.to_s
  end

  it 'should define the methods specified by Barney::MethodLookup::METHODS on the calling object.' do
    Barney do
      Barney::MethodLookup::METHODS.each do |method|
        assert_equal Barney::MethodLookup, method(method).owner
      end
    end
  end

  it 'should undefine the methods in Barney::MethodLookup::METHODS when finished.' do
    Barney do
      fork {}
    end

    Barney::MethodLookup::METHODS.each do |method|
      assert_raises(NoMethodError, "#{method} should be undefined!") { self.send(method) }
    end
  end
end
