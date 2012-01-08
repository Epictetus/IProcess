__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/iprocess
| Wiki            | https://github.com/robgleeson/iprocess/wiki
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  IProcess, short for _Inter Process Communication(IPC) Process_, is a    
  Domain Specific Language(DSL) that can be used to share Ruby objects     
  between processes on UNIX-like operating systems. The wiki has guide-style  
  tutorials you might want to check out, but the README covers the basics.  

  This project was formerly known as 'Barney'.

__WHY?__

I wanted to be able to:  

* Spawn a subprocess, apply restrictions to that subprocess, then collect   
  and send Ruby objects back  to the parent process.  
  (that was for a IRC bot evaluating Ruby code).

* Spawn multiple parallel jobs, then collect and send back Ruby objects to the  
  parent process.


__EXAMPLES__

__1.__

Sequential in nature (each subprocess must finish before another can execute):

    name = "rob"

    IProcess do |process|
      process.share :name
      
      process.fork do 
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


 
