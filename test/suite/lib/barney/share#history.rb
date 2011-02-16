describe Barney::Share do
  describe '#history' do

    it 'should confirm #history provides the correct history' do
      hash = {}
      expected = { 0 => { :hash => { 1 => 1 } }, 1 => { :hash => { 2 => 2 } }, 2 => { :hash => { 3 => 3 } } }
      object = Barney::Share.new
      object.share :hash

      [1,2,3].each do |e|
        pid = object.fork { hash.merge! e => e }
        Process.wait pid
      end

      object.sync
      assert_equal expected, object.history
    end

  end
end
