context('Barney::Share') do
  context('#synchronize') do
   
    context('Behavior') do
      
      asserts("that changes made to a local variable(which is shared between a child and parent " \
              "process) will be present after reassignment.") do
        a = 5
        barney = Barney::Share.new
        barney.share(:a)
        process_id = barney.fork do
          a = 6
        end
        Process.wait(process_id)
        barney.synchronize
        a == 6
      end

      asserts("that changes made to a local variable(which is shared between a child and parent " \
              "process) will be present after mutation.") do
        a = "abc"
        barney = Barney::Share.new
        barney.share(:a)
        process_id = barney.fork do
          a.sub!('a','b')
        end
        Process.wait(process_id)
        barney.synchronize
        a == "bbc"
      end

      asserts("that changes made to two local variables(which are shared between a child and " \
              "parent process) are present after reassignment.") do
      
        a = 10
        b = 20
        barney = Barney::Share.new
        barney.share(:a)
        barney.share(:b)
        process_id = barney.fork do
          a = 4
          b = 5
        end
        Process.wait(process_id)
        barney.synchronize
        a == 4 && b == 5
      end

      asserts 'that multiple subprocesses can be spawned, with variables modified in each, and the results remain ' +
              'consistent (See GH Issue 1)' do

        $times  = 2

        obj = Barney::Share.new
        obj.share :$times

        pid = obj.fork  { $times = 4 }
        pid2 = obj.fork { $times = 5 }
        pid3 = obj.fork { $times = 6 }
        obj.sync

        Process.wait pid
        Process.wait pid2
        Process.wait pid3
        $times == 6
      end

      asserts 'that #history provides the correct history' do
        a = {}

        obj = Barney::Share.new
        obj.share :a
      
        pid1 = obj.fork { a.merge! :foo => 'a' }
        pid2 = obj.fork { a.merge! :bar => 'b' }
        pid3 = obj.fork { a.merge! :baz => 'c' }

        obj.sync
        ret = obj.history.values.inject({}) { |memo,a| memo.merge! a[:a] }
        ret == { :foo => 'a', :bar => 'b', :baz => 'c' }
      end

    end

  end
end
  
