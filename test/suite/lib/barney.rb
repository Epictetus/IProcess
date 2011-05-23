describe 'Barney' do

  it 'should respond to all Barney::Share methods.' do
    methods = Barney::Share.instance_methods false
    methods.each do |meth|
      assert Barney.respond_to?(meth.to_sym), "Barney should respond to #{meth}"
    end
  end

end

describe '#Barney' do

  it 'should..' do
    name = 'Robert'

    Barney do
      share :name
      fork do
        name.slice! 3..5
      end
    end

    assert_equal "Rob", name
  end

end
