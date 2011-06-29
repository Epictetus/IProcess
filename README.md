 ![Barney Picture](http://i.imgur.com/VblLQ.png)

Barney makes sharing data between processes easy and natural by providing a simple and easy to use DSL.  
Barney is supported on any Ruby implementation that supports 1.8.7+, 1.9.1+, and that implements `Kernel.fork`.

Underneath the hood, Barney is using `Marshal` (the module) to serialize objects and send them across pipes created by `IO.pipe`.  
If an object can't be serialized by `Marshal`, it can't be shared.  That means objects such as anonymous modules, 
anonymous classes, and Proc objects can't be shared by Barney.

I'll give a brief overview of the public API down below.  
The README isn't meant to be the go-to for documentation, so if you'd like to learn more the [Guides](http://github.com/robgleeson/barney/wiki) 
have been written to help you along your way.  
The [API documentation](http://rubydoc.info/github/robgleeson/barney/master/) is written using YARD and takes full advantage of its features.


Usage
-----

**The Barney method**  
The Barney method executes each subprocess sequentially so shared data from the first subprocess is available to the next subprocess.  
It is especially useful if you want to perform some operation that should be restricted to a separate process, but be able to share the result 
of that operation with the parent process.  

```ruby
#!/usr/bin/env ruby
require 'barney'

Barney do
  name = "Robert"
  share :name

  fork do
    name.slice! 3..5
  end

  p name # "Rob"
end
```

**The Jobs method**  
The Jobs method is especially designed for running multiple jobs in parallel.  
The passed block is executed in one or more subprocesses, with the return value of each subprocess returned to you in an Array.  

```ruby
#!/usr/bin/env ruby
require 'barney' 

number  = 21
results = Jobs(3) { number + number }
p results # [42, 42, 42]
```
 


Documentation
--------------

**Guides**  

* [Wiki](https://github.com/robgleeson/barney/wiki)

**API**  

* [master (git)](http://rubydoc.info/github/robgleeson/barney/master/)
* [0.15.1](http://rubydoc.info/gems/barney/0.15.0/)
* [0.15.0](http://rubydoc.info/gems/barney/0.15.0/)
* [0.14.0](http://rubydoc.info/gems/barney/0.14.0/)
* [0.13.0](http://rubydoc.info/gems/barney/0.13.0/)
* [0.12.0](http://rubydoc.info/gems/barney/0.12.0/)
* [0.11.0](http://rubydoc.info/gems/barney/0.11.0/)
* [0.10.1](http://rubydoc.info/gems/barney/0.10.1/)  
* [0.10.0](http://rubydoc.info/gems/barney/0.10.0/)
* …


**Samples**

* [Samples](https://github.com/robgleeson/barney/tree/master/samples)

Install
--------
  
    $ [sudo] gem install barney

License
--------

Barney is released under the [_MIT License_](http://en.wikipedia.org/wiki/MIT_License).  
See [LICENSE](http://github.com/robgleeson/barney/blob/master/README.md) for details!  
All versions before 0.13.0 are Lesser GPL(LGPL) licensed.


