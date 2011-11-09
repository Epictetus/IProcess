if RUBY_VERSION[0..2] == "1.8"
  class Symbol
    # Taken from the ppl at the Rubinius project:
    # https://github.com/rubinius/rubinius/blob/master/kernel/common/symbol19.rb#L2-6 
    def <=>(other)
      return unless other.kind_of? Symbol
      to_s <=> other.to_s
    end
  end
end
