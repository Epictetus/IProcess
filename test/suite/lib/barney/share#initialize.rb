describe Barney::Share do
  
  describe '#initialize' do
  
    it 'should take a block' do
      called = false
      
      Barney::Share.new do |obj| 
        called = true 
      end

      assert_equal true, called
    end

  end

end
