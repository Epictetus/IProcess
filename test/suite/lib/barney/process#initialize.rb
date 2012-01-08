describe IProcess::Process do

  describe '#initialize' do

    it 'should take a block' do
      called = false

      IProcess::Process.new do |obj|
        called = true
      end

      assert_equal true, called
    end

  end

end
