 ![Barney Picture](http://i.imgur.com/VblLQ.png)

Barney makes sharing data between processes easy and natural by providing a simple and easy to use DSL.  
Barney is supported on any Ruby implementation that supports 1.8.7+, 1.9.1+, and that implements `Kernel.fork`.

If you're looking for a library to do parallel jobs, check out [Parallel](https://github.com/grosser/parallel).  
While possible in Barney, it was never a design goal and I'd definitely recommend you check out _Parallel_ instead.

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

__Magic "Barney" method__

The magic "Barney" method handles synchronization of data between the child and parent process, something you normally do
manually with the `Barney::Share#sync` method, and it also collects the status of any subprocesses you spawn.

    #!/usr/bin/env ruby
    # Magic "Barney" method
    require 'barney'
    name = "Robert"

    Barney do
      share :name

      fork do
        name.slice! 3..5
      end
    end

    p name # "Rob"

 __Barney module__

The "Barney" module forwards requests onto a single instance of `Barney::Share`, where the DSL is implemented.  
You can of course use `Barney::Share` directly, which ever method you prefer is entirely up to you and what your situation requires.

    #!/usr/bin/env ruby
    # Barney module sample
    # Messages are forwarded onto a single instance of Barney::Share.
    require 'barney'

    Barney.share :name
    
    Barney.fork do 
      name.slice! 3..5
    end

    Barney.wait_all
    Barney.sync

    p name # "Rob"

* _More!_  
  Check out the [samples](https://github.com/robgleeson/barney/tree/master/samples) directory.  
  Check out the API docs, too.

* _Notes_  
  The DSL is implemented in _Barney::Share_.  
  You can create instances of(or subclasses) of _Barney::Share_ if you need to.  
  
Documentation
--------------

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/barney/master/)
* [0.14.0](http://rubydoc.info/gems/barney/0.14.0/)
* [0.13.0](http://rubydoc.info/gems/barney/0.13.0/)
* [0.12.0](http://rubydoc.info/gems/barney/0.12.0/)
* [0.11.0](http://rubydoc.info/gems/barney/0.11.0/)
* [0.10.1](http://rubydoc.info/gems/barney/0.10.1/)  
* [0.10.0](http://rubydoc.info/gems/barney/0.10.0/)
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

Barney is released under the [_MIT License_](http://en.wikipedia.org/wiki/MIT_License).  
See [LICENSE](http://github.com/robgleeson/barney/blob/master/README.md) for details!  
All versions before 0.13.0 are Lesser GPL(LGPL) licensed.


