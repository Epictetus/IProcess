describe 'Barney' do

  it 'should respond to all Barney::Share methods.' do
    methods = Barney::Share.instance_methods false
    methods.each do |meth|
      assert Barney.respond_to?(meth.to_sym), "Barney should respond to #{meth}"
    end
  end

end

describe '#Barney' do

  it 'should synchronize data using the #Barney() method.' do
    name = 'Robert'

    Barney do
      share :name
      fork { name.slice! 3..5 }
      fork { name.slice! 1..2 }
    end

    assert_equal "R", name
  end

end
