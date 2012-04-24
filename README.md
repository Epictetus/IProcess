__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/IProcess
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  IProcess, short for _Inter Process Communication(IPC) Process_, is a collection 
  of classes you can use to transport Ruby objects between processes running on 
  UNIX-like operating systems. 

__EXAMPLES__

__1.__

A single subprocess is spawned:
  
    message = IProcess.spawn { [:yes, :no] }
    p message # => [[:yes, :no]]

__2.__

A unit of work does not need to be a block, though, and the number of 
subprocesses you can spawn is variable (5, in this example):

    class Worker
      def initialize
        @num = 1
      end

      def call
        @num + 1
      end
    end

    IProcess.spawn(5, Worker.new) # => [2, 2, 2, 2, 2]


__PLATFORM SUPPORT__

_supported_

  * Rubinius (1.9 mode) 
  * CRuby (1.9)

_unsupported_
  
  * CRuby 1.8
  * MacRuby
  * JRuby

__INSTALL__

gem install iprocess
