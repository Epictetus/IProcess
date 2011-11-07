describe Barney::Process do
  
  describe '#unshare' do

    before do
      @instance = Barney::Process.new
    end

    it 'should assert a variable can be unshared before a subprocess is spawned.' do
      x = 5

      @instance.share :x
      @instance.unshare :x 
      pid = @instance.fork do 
        x = 6 
      end
      Process.wait pid
      @instance.sync
      
      assert_equal 5, x
    end
    
    it 'should assert a shared variable is removed from #variables.' do
      x = 5
      @instance.share :x
      @instance.unshare :x
      assert_equal true, @instance.variables.empty?
    end

 end

end

