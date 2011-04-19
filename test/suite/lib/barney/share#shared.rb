describe Barney::Share do

  describe '#share' do
  
    it "should assert duplicates aren't stored." do
      instance = Barney::Share.new
      instance.share :a, :a, :a, :a
      instance.variables == [:a]
    end

  end

end
