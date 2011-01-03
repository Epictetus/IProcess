context 'Barney::Share' do
  context '#shared' do
  
    setup do 
      obj = Barney::Share.new
      obj.share :a, :b, :c
      obj.shared
    end

    asserts 'that #shared returns a list of variables being shared.' do 
      topic == [ :a, :b, :c ] 
    end

  end
end
