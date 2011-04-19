describe Barney::Share do
  
  describe '#history' do

    it 'should provide the correct history.' do     
      object = Barney::Share.new
      object.share :message
      message = ""

      %w(a b c).each do |letter|
        pid = object.fork { message << letter }
        Process.wait pid
      end

      object.sync

      history = object.history
      assert_equal true, history.all? { |item| item.variable == :message }
      assert_equal "abc", history.map { |item| item.value }.join 
    end

  end

end
