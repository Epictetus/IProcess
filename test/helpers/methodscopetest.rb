class MethodScopeTest

  attr_reader :run

  def initialize
    @run = false
  end

  def run
    @run = true
  end

  def execute
    Barney do
      share :@run
      fork { run }
    end
  end

end
