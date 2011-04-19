 ![Barney Picture](http://ompldr.org/vNnUwNA)

Barney tries to make the sharing of data between processes as easy and **natural** as possible.  
Barney is developed to run on Ruby 1.9.1 or later, but it may work on earlier versions of Ruby as well.

## Limitations

* Sharable objects  
  Behind the scenes, Barney is using Marshal to send data between processes.  
  Any object that can be dumped through Marshal.dump can be shared.  
  This excludes anonymous modules, anonymous classes, Proc objects, and possibly some other objects I
  cannot think of.

* Thread safety  
  Barney is thread-safe as long as one instance of Barney::Share is used per-thread.  
  There is a mutex lock in place, but it only concerns Barney::Share#synchronize, where data is shared
  among all instances of Barney::Share.

## Examples

Okay, now that we've got that out of the way, let's see what using Barney is like:  
(The [Samples](https://github.com/robgleeson/barney/tree/develop/samples) directory has more examples …)

**Basic**

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


## Install

RubyGems.org  

      gem install barney

Github  

      git clone git://github.com/robgleeson/barney.git
      cd barney
      gem build *.gemspec
      gem install *.gem

I'm following the [Semantic Versioning](http://www.semver.org) policy.  

## Documentation

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/Barney/master/)
* [0.8.0](http://rubydoc.info/gems/barney/0.8.0/)
* [0.7.0](http://rubydoc.info/gems/barney/0.7.0)
* [0.6.0](http://rubydoc.info/gems/barney/0.6.0)
* [0.5.0](http://rubydoc.info/gems/barney/0.5.0)
* [0.4.1](http://rubydoc.info/gems/barney/0.4.1)
* [0.4.0](http://rubydoc.info/gems/barney/0.4.0)
* …


## License

Barney is released under the Lesser GPL(LGPL).  


