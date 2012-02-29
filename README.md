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

* Spawn a subprocess, apply restrictions to that subprocess, then collect   
  and send Ruby objects back  to the parent process.  
  (that was for a IRC bot evaluating Ruby code).

* Spawn multiple parallel jobs, then collect and send back Ruby objects to the  
  parent process.

 
__COST?__
     
  If you're using IProcess for parallelism, a subprocess will cost you more than   
  a thread (in terms of time to create the subprocess, and the memory it consumes   
  - no implementation IProcess supports has a CoW-friendly garbage collector).  

  Despite the GIL on CRuby, for IO bound operations it can run threads in    
  parallel and may perform better. You should benchmark IProcess      
  and threads for your use-case before choosing either. IProcess may be better,   
  or it may be worse. Normally, for long running non-IO bound operations,   
  parallel subprocesses outperform CRuby threads. Profile, benchmark, and I hope     
  IProcess is useful to you :)  

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


 
