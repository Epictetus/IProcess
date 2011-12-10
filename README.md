__OVERVIEW__


| Project         | barney    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/barney
| Wiki            | https://github.com/robgleeson/barney/wiki
| Documentation   | http://rubydoc.info/gems/barney/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  A Domain Specific Language(DSL) for sharing data between processes on 
  UNIX-like operating systems.  
  See the Wiki and API documentation for more information.


__WHY?__

So I could:

* Spawn a subprocess, apply restrictions, then collect and send data back   
  to the parent process.

* Spawn multiple parallel jobs, then collect and return data.  

The first motiviation is solved through the example down below.  
The second  motivation is solved by the Jobs() method. Wiki has more info :)


__EXAMPLES__

    name = "rob"

    Barney do
      share :name
      
      fork do 
        name.capitalize!
      end
    end

    p name # => "Rob"
    

__INSTALL__

  gem install barney

__LICENSE__

  
  See LICENSE.txt


 
