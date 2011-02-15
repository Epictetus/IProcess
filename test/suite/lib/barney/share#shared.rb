describe Barney::Share do
  describe '#shared' do

    it 'should return a list of shared variables' do 
      obj = Barney::Share.new
      obj.share :a, :b, :c
      assert_equal true, [:a, :b, :c].all? { |variable| obj.shared.include? variable }
    end

  end
end
