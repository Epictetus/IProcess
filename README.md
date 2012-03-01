__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/IProcess
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  IProcess, short for _Inter Process Communication(IPC) Process_, is a    
  Domain Specific Language(DSL) that can be used to share Ruby objects     
  between processes on UNIX-like operating systems. The README covers the   
  basics, and there is the API documentation for everything else.

  This project was formerly known as 'Barney'.

__WHY?__

I wanted to be able to:  

* Share Ruby objects between a subprocess and its parent process.
* Share Ruby objects between multiple subprocesses running in parallel and their parent.  

 
__COST?__
     
  If you're using IProcess for parallelism, a subprocess will cost you more than   
  a thread (in terms of time to create the subprocess, and the memory it consumes   
  - no implementation IProcess supports has a CoW-friendly garbage collector).  

  Despite the GIL on CRuby, for IO bound operations it can run threads in  
  parallel and may perform better. For long running non-IO bound operations,  
  though, parallel subprocesses usually outperform CRuby threads. You should   
  profile and benchmark IProcess and threads for your use-case before choosing   
  either. IProcess may be better, or it may be worse.  

__EXAMPLES__

__1.__

Sequential in nature (each subprocess must finish before another can execute):

    name = "rob"

    IProcess.new do
      share :name
      
      fork do 
        name.capitalize!
      end
    end

    p name # => "Rob"
    
__2.__

A subprocess is spawned 5 times, in parallel:

    workload = IProcess::Job.spawn(5) do
      # Replace this with heavily CPU-bound code ;-) 
      1 + 1
    end

    p workload # [2, 2, 2, 2, 2]

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

__LICENSE__

  
  See LICENSE.txt


 
