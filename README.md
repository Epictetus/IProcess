 ![Barney Picture](http://ompldr.org/vNnUwNA)

Barney tries to make the sharing of data between processes as easy and **natural** as possible.  

## Sharable objects
Behind the scenes, Barney is using Marshal to send data between processes.  
Any object that can be dumped through Marshal.dump can be shared.  
This excludes anonymous modules, anonymous classes, Proc objects, and possibly some other objects I
cannot think of.

## Thread safety

Barney is thread-safe as long as one instance of Barney::Share is used per-thread.  
There is a mutex lock in place, but it only concerns Barney::Share#synchronize, where data is shared
among all instances of Barney::Share.

## Examples

Okay, now that we've got that out of the way, let's see what using Barney is like.

**Example A**

      #!/usr/bin/env ruby
      require 'barney'

      message = 'foo'
      $times  = 2

      obj = Barney::Share.new
      obj.share :message, :$times    
      pid = obj.fork do 
        message.sub! 'f', 'b'
        $times += 1
      end

      Process.wait pid
      obj.sync
      
      puts message * $times # output is 'boobooboo'.
   
## Documentation

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/Barney/master/)
* [0.3.1](http://rubydoc.info/gems/barney/0.3.1)
* [0.2.0](http://rubydoc.info/gems/barney/0.2.0)
* [0.1.0](http://rubydoc.info/gems/barney/0.1.0)

## License

Barney is released under the LGPL.  
You are free to **use** this library in free or commercial software, and license that software however you want, 
but as soon as you modify the library itself, 
you must share your changes under the same license. :)

## Install

      gem install barney

The repository has a gemspec you can build and install from, too.
I'm following the [Semantic Versioning](http://www.semver.org) policy.
