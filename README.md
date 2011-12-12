__OVERVIEW__


| Project         | barney    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/barney
| Wiki            | https://github.com/robgleeson/barney/wiki
| Documentation   | http://rubydoc.info/gems/barney/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  A Domain Specific Language(DSL) that can be used to share data between 
  processes on UNIX-like operating systems.  
  See the Wiki and API documentation for more information.


__WHY?__

So I could:

* Spawn a subprocess, apply restrictions, then collect and send data back   
  to the parent process (that was for a IRC bot evaluating Ruby code).

* Spawn multiple parallel jobs, then collect and return data.  


__PLATFORM SUPPORT__

_supported_

  * Rubinius
  * CRuby (1.8 / 1.9)

_unsupported_
  
  * MacRuby
  * JRuby


__EXAMPLES__

__1.__

Sequential in nature (each subprocess must finish before another can execute):

    name = "rob"

    Barney do
      share :name
      
      fork do 
        name.capitalize!
      end
    end

    p name # => "Rob"
    
__2.__

A subprocess is spawned 5 times, in parallel:

    workload = Jobs(5) {
      1 + 1
    }

    p workload # [2, 2, 2, 2, 2]

__INSTALL__

  gem install barney

__LICENSE__

  
  See LICENSE.txt


 
