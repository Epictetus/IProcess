## Barney

Barney tries to make the sharing of data between processes as easy and **natural** as possible.  

## Limitations

* Behind the scenes, Barney is using Marshal to serialize ruby objects, and therefore suffers from
  the downfalls of Marshal itself. Proc objects, Binding objects, Anonymous classes, 
  and Anonymous modules, cannot be shared.

* Barney is not thread-safe. I plan to change this in the future.

## Examples

Okay, now that we've got that out of the way, let's see what using Barney is like.

**Example A**

    #!/usr/bin/env ruby
    require('barney')

    obj = Barney::Share.new
    obj.share(:a)
    a = 5

    pid = obj.fork { a = 6 }
    Process.wait(pid)
    obj.synchronize
    
    puts a # output is 6.

**Example B**

    #!/usr/bin/env ruby
    require('barney')

    obj = Barney::Share.new
    obj.share(:@a, :b) 

    @a = 2
    b  = 4
    pid = obj.fork do
        @a = 123
        b  = 456
    end
    Process.wait(pid)
    obj.synchronize

    puts "#{@a} and #{b}"

The API is definitely not set in stone. 0.1.0 is planned for release as a gem soon.  
I'm following SemVer as my versioning policy (http://www.semver.org)
