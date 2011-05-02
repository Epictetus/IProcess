 ![Barney Picture](http://i.imgur.com/VblLQ.png)

Barney makes sharing data between processes easy and natural by providing a simple and easy to use DSL.  
Barney is developed against Ruby 1.9.1 and later, but it may work on earlier versions of Ruby as well.

Limitations  
-----------

* Sharable objects  
  Behind the scenes, Barney is using Marshal to send data between processes.   
  Any object that can be dumped through Marshal.dump can be shared.  
  This excludes anonymous modules, anonymous classes, Proc objects, and possibly some other objects I cannot think of.

* Thread safety  
  Barney is thread-safe as long as one instance of Barney::Share is used per-thread.  
  There is a mutex lock in place, but it only concerns Barney::Share#synchronize, where data is shared among all 
  instances of Barney::Share.

Usage
-----
The [samples](https://github.com/robgleeson/barney/tree/master/samples) directory has more samples.  

* "Barney" module   
  The _Barney_ module forwards messages to an instance of _Barney::Share_: 

        #!/usr/bin/env ruby
        require 'barney'

        Barney.share :name
        name = 'Robert'

        pid = Barney.fork do 
          name.slice! 0..2
        end

        Process.wait pid
        Barney.sync

        puts name # "Rob"

* "Barney::Share" class    
  The _Barney::Share_ class implements the DSL:

        #!/usr/bin/env ruby
        require 'barney'

        obj = Barney::Share.new
        obj.share :message
        message = 'Hello, '

        pid = obj.fork do 
          message << 'World!'
        end

        Process.wait pid
        obj.sync
        
        puts message # 'Hello, World!' 

 

Documentation
--------------

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/barney/master/)
* [0.10.0](http://rubydoc.info/gems/barney/0.10.0/)
* [0.9.1](http://rubydoc.info/gems/barney/0.9.1/)
* [0.9.0](http://rubydoc.info/gems/barney/0.9.0/)
* [0.8.1](http://rubydoc.info/gems/barney/0.8.1/)
* [0.8.0](http://rubydoc.info/gems/barney/0.8.0/)
* [0.7.0](http://rubydoc.info/gems/barney/0.7.0)
* …

  

Install
--------

RubyGems.org  

      gem install barney

Github  

      git clone git://github.com/robgleeson/barney.git
      cd barney
      gem build *.gemspec
      gem install *.gem

I'm following the [Semantic Versioning](http://www.semver.org) policy.  


License
--------

Barney is released under the Lesser GPL(LGPL).  


