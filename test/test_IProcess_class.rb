context IProcess do

  context 'initialize' do
    it 'calls a block, if given.' do
      mock = MiniTest::Mock.new
      mock.expect :ok, nil
      
      IProcess.new do
        mock.ok
      end

      mock.verify
    end
  end

  context 'share' do
    it 'shares a variable.' do
      IProcess.new do
        share :a
        variables.must_equal [:a]
      end
    end

    it "does not store duplicate variables" do
      IProcess.new do
        share :a, :a
        variables.must_equal [:a]
      end
    end
  end

  context 'unshare' do
    it "unshares a variable." do
      IProcess.new do
        share :a
        unshare :a
        variables.must_be_empty
      end
    end
  end

  context 'fork' do
    it 'returns the Process ID(PID) on success.' do
      pid = IProcess.new.fork { }
      assert_equal Fixnum, pid.class
    end

    it 'raises if no block is given.' do
      obj = IProcess.new

      assert_raises(ArgumentError) do
        obj.fork
      end
    end

    it 'synchronizes a shared variable.' do
      local = 1

      IProcess.new do
        share :local
        fork { local = 2 }
      end

      local.must_equal(2)
    end

    it 'synchronizes two shared variables.' do
      local1, local2 = 1, 2

      IProcess.new do
        share :local1, :local2

        fork do
          local1 = 5
          local2 = 9
        end
      end

      local1.must_equal(5)
      local2.must_equal(9)
    end

    it 'synchronizes a instance variable.' do
      @ivar = :ivar

      IProcess.new do
        share :@ivar

        fork do
          @ivar = 2
        end
      end

      @ivar.must_equal(2)
    end

    it 'provide access to surrounding local variables.' do
      local = :local

      IProcess.new do
        fork do
          local.must_equal(:local)
        end
      end
    end
  end

end

