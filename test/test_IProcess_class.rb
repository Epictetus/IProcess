context IProcess do

  context 'initialize' do
    it 'must call block if given.' do
      mock = MiniTest::Mock.new
      mock.expect :ok, nil

      IProcess.new do
        mock.ok
      end
    end
  end

  context 'share' do
    it 'must share a variable.' do
      IProcess.new do
        share :a
        variables.must_equal [:a]
      end
    end

    it "must not store duplicate variables" do
      IProcess.new do
        share :a, :a
        variables.must_equal [:a]
      end
    end
  end

  context 'unshare' do
    it "must unshare a variable." do
      IProcess.new do
        share :a
        unshare :a
        variables.must_be_empty
      end
    end
  end

  context 'fork' do
    it 'must return the PID on success.' do
      pid = IProcess.new.fork { }
      assert_equal Fixnum, pid.class
    end

    it 'must raise a ArgumentError if a block is not given.' do
      obj = IProcess.new

      assert_raises ArgumentError do
        obj.fork
      end
    end

    it 'must synchronize a shared variable.' do
      variable = :o_O

      IProcess.new do
        share :variable
        fork { variable = :ok }
      end

      variable.must_equal(:ok)
    end

    it 'must synchronize two shared variables.' do
      variable1 = :o_O
      variable2 = :UnF

      IProcess.new do
        share :variable1, :variable2
        fork do
          variable1 = 123
          variable2 = 456
        end
      end

      variable1.must_equal(123)
      variable2.must_equal(456)
    end

    it 'must synchronize a instance variable.' do
      @ivar = :o_O

      IProcess.new do
        share :@ivar

        fork do
          @ivar = :ok
        end
      end

      @ivar.must_equal(:ok)
    end

    it 'must provide access to a local variable.' do
      local = :local

      IProcess.new do
        fork do
          local.must_equal(:local)
        end
      end
    end

  end

end

