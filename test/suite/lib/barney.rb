describe 'Barney' do

  it 'should respond to all Barney::Share methods.' do
    methods = Barney::Share.instance_methods false
    methods.each do |meth|
      assert Barney.respond_to?(meth.to_sym), "Barney should respond to #{meth}"
    end
  end

end
