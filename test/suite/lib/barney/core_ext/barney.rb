describe '#Barney' do

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

  it 'should evaluate the passed block in the context it is called in' do
    klass = nil

    Barney do
      share :klass
      fork { klass = self.class.to_s }
    end

    assert_equal klass, self.class.to_s
  end

  it 'should define the methods of Barney::Share for the duration of its call.' do
    Barney do
      self.methods.each do |meth|
        if Barney::Share.instance_methods(false).include? meth
          assert_equal Barney::MethodLookup, method(meth).owner
        end
      end
    end
  end

  it 'should undefine any methods it defines for the context of a single call.' do
    Barney do
      share :@foo
      fork { @foo = "bar" }
    end

    Barney::Share.instance_methods(false).each do |meth|
      assert_raises(NoMethodError, "#{meth} should be undefined!") { self.send(meth) }
    end
  end
end
