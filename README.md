 ![Barney Picture](http://i.imgur.com/VblLQ.png)

Barney makes sharing data between processes easy and natural by providing a simple and easy to use DSL.  
Barney is supported on any Ruby implementation that supports 1.8.7+, 1.9.1+, and that implements `Kernel.fork`.

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

* **Barney()**

    The Barney() method is a method you can use to share data between processes easily.  
    It provides an extremely simple and expressive way to share data.


        require 'barney'
        
        name = "Robert"
        
        Barney do
          share :name

          fork do
            name.slice! 3..5
          end
        end

        p name # "Rob"


* **Jobs()**

    The _Jobs_ method spawns a number of workers(represented by a block) as subprocesses.  
    The return value of each block is returned to you in an array.

    This method is especially designed for those who want to run jobs in parallel, usually for 
    long computations or to take advantage of multiple cores, while still being able to share data.
        
        require 'barney'
        result = Jobs(5) { 42 } # [ 42, 42, 42, 42, 42 ]

* **… And finally!**

    The DSL is implemented on top of the `Barney::Share` class, which can be of course used directly by you.  
    The above methods are implemented using `Barney::Share` under the hood.  
    To learn more, check out the [samples](https://github.com/robgleeson/barney/tree/master/samples),
    [the wiki](https://github.com/robgleeson/barney/wiki), and of course the API docs.
    
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


