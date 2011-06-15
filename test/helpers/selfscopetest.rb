class SelfScopeTest

  attr_reader :self

  def initialize
    @self = nil
  end

  def execute
    Barney do
      share :@self
      fork { @self = self.class.to_s }
    end
  end

end
