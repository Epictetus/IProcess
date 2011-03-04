 ![Barney Picture](http://ompldr.org/vNnUwNA)

Barney tries to make the sharing of data between processes as easy and **natural** as possible.  
Barney is developed against Ruby 1.9.1 or later. I'm not knowingly supporting earlier versions of Ruby.

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

**Basic**

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
 
**Sequential Jobs**
      
      #!/usr/bin/env ruby
      require 'barney'

      a = "12"

      obj = Barney::Share.new
      obj.share :a

      3.upto(4).each do |i|
        pid = obj.fork { a << i.to_s }
        Process.wait pid
        obj.sync
      end

      a # => "1234"

**Paralell Jobs**

      #/usr/bin/env ruby
      require 'barney'

      results = {}
      pids    = []

      obj = Barney::Share.new
      obj.share :results

      [1,2,3].each do |e|
        pids << obj.fork do 
          results.merge!(e => e)
        end
      end

      pids.each { |pid| Process.wait pid }
      obj.sync

      obj.history.each_value do |history| 
        results.merge! history[:results]
      end

      puts results.inspect # => { 1 => 1, 2 => 2, 3 => 3 }

## Documentation

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/Barney/master/)
* [0.6.0](http://rubydoc.info/gems/barney/0.6.0)
* [0.5.0](http://rubydoc.info/gems/barney/0.5.0)
* [0.4.1](http://rubydoc.info/gems/barney/0.4.1)
* [0.4.0](http://rubydoc.info/gems/barney/0.4.0)
* …

## License

Barney is released under the Lesser GPL(LGPL).  

## Install

      gem install barney

The repository has a gemspec you can build and install from, too.
I'm following the [Semantic Versioning](http://www.semver.org) policy.
