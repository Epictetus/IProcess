describe Barney::Share do
  describe '#history' do

    it 'should provide the correct history.' do     
      object = Barney::Share.new
      object.share :shared
      shared = ""

      %w(a b c).each do |e|
        pid = object.fork { shared << e }
        Process.wait pid
      end

      object.sync

      history = object.history
      assert_equal true, history.all? { |item| item.variable == :shared }
      assert_equal "abc", history.map { |item| item.value }.join 
    end

  end
end
