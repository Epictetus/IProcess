suite('Barney') do
  suite('Share') do
    suite('#fork') do

      suite('Return values.') do
      
        exercise('When #fork has finished executing.') do
          obj         = Barney::Share.new
          @process_id = obj.fork { }
          Process.wait(@process_id)
        end

        verify('It returns the Process ID of the spawned process.') do
          @process_id.class == Fixnum
        end

      end

      suite('Raises.') do
        
        exercise('When a block or Proc object is not supplied to #fork.') do
          obj = Barney::Share.new
          begin
            obj.fork
          rescue ArgumentError => e
            @ret = true
          end
        end

        verify('An ArgumentError is raised.') do
          @ret == true
        end

      end

      suite('Behavior.') do
      
        exercise('When a local variable is shared between a child and parent process.') do 
          obj = Barney::Share.new
          obj.share(:a)
          a = 1
          process_id = obj.fork do
            a = 2
          end
          Process.wait(process_id)
          obj.synchronize
          @ret = a
        end

        verify('Changes made to the local variable are present after reassignment.') do
          @ret == 2
        end

        exercise('When a local variable is shared between a child and parent process.') do 
          obj = Barney::Share.new
          obj.share(:a)
          a = "abc"
          process_id = obj.fork do
            a.sub!('a', 'b')
          end
          Process.wait(process_id)
          obj.synchronize
          @ret = a
        end

        verify('Changes made to the local variable are present after mutation.') do
          @ret == "bbc"
        end

        exercise('When two local variables are shared between a child and parent process.') do 
          obj = Barney::Share.new
          obj.share(:a)
          obj.share(:b)
          a = b = 1
          process_id = obj.fork do
            a = 2
            b = 3
          end
          Process.wait(process_id)
          obj.synchronize
          @ret = [a, b]
        end

        verify('Changes made to the local variables are present after reassignment.') do
          @ret == [ 2,3 ]
        end

        exercise('When a child process sleeps for 5 seconds and the parent process does not wait.') do
          obj = Barney::Share.new
          obj.share(:a)
          a = 2
          process_id = obj.fork { sleep(5); a = 10 }
          Process.detach(process_id)
          obj.synchronize
          @ret = a
        end

        verify('The changes to the shared variable still appear after a call to #synchronize.') do
          @ret == 10
        end

      end

    end
  end
end
