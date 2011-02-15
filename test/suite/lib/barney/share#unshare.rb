describe Barney::Share do
  describe '#unshare' do

    before do
      @a      = 5
      @object = Barney::Share.new
    end

    it 'should confirm a variable can be unshared before a subprocess is spawned.' do
      @object.share :@a
      @object.unshare :@a 
      pid = @object.fork { @a = 6 }
      Process.wait pid
      @object.sync
      
      assert_equal 5, @a
    end
    
    it 'should confirm a shared variable is removed from #shared.' do
      @object.share :@a
      @object.unshare :@a
      assert_equal true, @object.shared.empty?
    end

 end
end

