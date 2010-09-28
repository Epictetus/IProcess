context('Barney::Share') do
  context('#fork') do
    
    context('Return values.') do

      setup do
        process_id = Barney::Share.new.fork { }
      end

      asserts("that the Process ID(PID) of the spawned child process is returned on success.") do
        topic.class == Fixnum
      end

    end

    context("raises") do

      setup do
        begin
          Barney::Share.new.fork 
        rescue ArgumentError => e
          true
        end
      end

      asserts('that an ArgumentError is raised when a Proc object or block is not supplied.') do
        topic == true
      end
    
    end

  end
end

