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
    require('barney')

    a = 2+3

    obj = Barney::Share.new
    obj.share(:a)
    pid = obj.fork { a = 6 }
    Process.wait(pid)
    obj.synchronize
    
    puts a # output is 6.

**Example B**

    #!/usr/bin/env ruby
    require('barney')

    @a = 1+1
    b  = 2+2

    obj = Barney::Share.new
    obj.share(:@a, :b) 
    pid = obj.fork do
        @a = 123
        b  = 456
    end
    Process.wait(pid)
    obj.synchronize

    puts "#{@a} and #{b}" # output is "123 and 456"

## Install

      gem install barney

The repository has a gemspec you can build and install from, too.
I'm following the [Semantic Versioning](http://www.semver.org) policy.
