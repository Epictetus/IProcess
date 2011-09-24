__OVERVIEW__


| Project         | barney    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/barney
| Wiki            | https://github.com/robgleeson/barney/wiki
| Documentation   | http://rubydoc.info/gems/barney/frames 
| Author          | Rob Gleeson             


__DESCRIPTION__

  A Domain Specific Language(DSL) to share data between processes on UNIX-like operating systems.  
  See the Wiki and API documentation for more information.


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


 
