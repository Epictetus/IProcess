suite('Barney') do
  suite('Share') do
    suite('#fork') do

      suite('Return values.') do
      
        exercise('When #fork has finished executing.') do
          obj = Barney::Share.new
          @ret = obj.fork { }
          Process.wait(@ret)
        end

        verify('It returns the Process ID of the spawned process.') do
          @ret.class == Fixnum
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
          pid = obj.fork do
            a = 2
          end
          Process.wait(pid)
          @ret = a
        end

        verify('Changes made to the local variable are present after reassignment.') do
          @ret == 2
        end

        exercise('When a local variable is shared between a child and parent process.') do 
          obj = Barney::Share.new
          obj.share(:a)
          a = "abc"
          pid = obj.fork do
            a.sub!('a', 'b')
          end
          Process.wait(pid)
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
          obj.fork do
            a = 2
            b = 3
          end
          @ret = [a, b]
        end

      end

    end
  end
end
