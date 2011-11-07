describe Barney::Process do

  describe '#share' do
  
    it "should assert duplicates aren't stored." do
      instance = Barney::Process.new
      instance.share :a, :a, :a, :a
      instance.variables == [:a]
    end

    it "should assert variable names are stored as Symbols" do
      instance = Barney::Process.new
      instance.share "a", "b"
      instance.variables == [:a, :b]
    end

  end

end
