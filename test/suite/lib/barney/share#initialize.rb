describe Barney::Share do
  describe '#initialize' do
  
    it 'should take a block' do
      actual = false
      Barney::Share.new { |obj| actual = true }
      assert_equal true, actual
    end

  end
end
