require 'delegate'

class Barney::Symbol < Delegator
  
  def initialize symbol
    @symbol = symbol.to_sym
    super(@symbol)
  end

  def __getobj__
    @symbol
  end

  def __setobj__ obj
    @symbol = obj
  end

  def eql? other
    @symbol.eql?(other.__getobj__)
  end

  def hash
    @symbol.hash
  end

  if RUBY_VERSION[0..2] == "1.8"
    def <=>(other)
      return unless other.kind_of? Barney::Symbol
      to_s <=> other.to_s
    end
  end

end
