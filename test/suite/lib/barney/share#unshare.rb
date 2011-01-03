context 'Barney::Share' do
  context '#unshare' do

    asserts 'that a variable can be unshared before a subprocess is spawned.' do
      a = 5
      
      obj = Barney::Share.new 
      obj.share :a
      obj.unshare :a 
      pid = obj.fork { a = 6 }
      Process.wait pid
      obj.synchronize
      
      a == 5
    end
    
    asserts 'that a unshared variable is removed from @shared.' do
      a = 5
      
      obj = Barney::Share.new
      obj.share :a
      obj.unshare :a
      obj.shared.empty?
    end

 end
end

