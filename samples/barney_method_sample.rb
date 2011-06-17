require 'barney'

class Example

  attr_reader :name

  def initialize
    @name = "Rob"
  end

  def execute!
    Barney do
      share :@name
      fork { @name = "Bob" }
    end
  end

end

example = Example.new
example.execute!
p example.name # => "Bob"
