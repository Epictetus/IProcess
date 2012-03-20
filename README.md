__OVERVIEW__


| Project         | IProcess    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/IProcess
| Documentation   | http://rubydoc.info/gems/iprocess/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  IProcess, short for _Inter Process Communication(IPC) Process_, is a  
  Domain Specific Language(DSL) that you can use to transport Ruby objects  
  between processes on UNIX-like operating systems. Objects are (de)serialized  
  using the Marshal module included with Ruby and transported across pipes.  

  It can be thought of as a high-level approach to IPC or an abstraction on top  
  of IPC primitives. None of the nitty gritty details of IPC are exposed in the  
  public interface. The project was formerly known as 'Barney', and is one of  
  the many  experimentations I've had on mechanisms for IPC in Ruby.

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

    workload = 
    IProcess::Job.spawn(5) {
      # Replace this with heavily CPU-bound code ;-) 
      1 + 1
    }

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
