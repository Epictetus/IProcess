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

        pid = obj.fork do
          $times = 4
        end

        pid2 = obj.fork do
          $times = 5
        end

        pid3 = obj.fork do
          $times = 6
        end

        Process.wait pid
        obj.sync
        a = $times
        Process.wait pid2
        obj.sync
        b = $times

        Process.wait pid3
        obj.sync
        c = $times
        
        a == 4 && b == 5 && c == 6
      end

    end

  end
end
  
