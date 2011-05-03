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

* _More!_  
  Check out the [samples](https://github.com/robgleeson/barney/tree/master/samples) directory or if you're looking 
  for precise and detailed info, check out the API docs.

* _Notes!_  
  It's worth mentioning that the _Barney_ module is passing method calls to an instance of _Barney::Share_, 
  where the DSL is implemented. If you prefer, or your situation requires, feel free to create instance(s) of 
  _Barney::Share_ yourself.  


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

Documentation
--------------

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/barney/master/)
* [0.11.0](http://rubydoc.info/gems/barney/0.11.0/)
* [0.10.1](http://rubydoc.info/gems/barney/0.10.1/)  
* [0.10.0](http://rubydoc.info/gems/barney/0.10.0/)
* [0.9.1](http://rubydoc.info/gems/barney/0.9.1/)
* [0.9.0](http://rubydoc.info/gems/barney/0.9.0/)
* [0.8.1](http://rubydoc.info/gems/barney/0.8.1/)
* …


License
--------

Barney is released under the Lesser GPL(LGPL).  


