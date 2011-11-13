module Barney
  
  #
  # @attr [Symbol] variable 
  #   The name of the variable associated with _in_, and _out_.
  #
  # @attr [IO] input     
  #   The pipe which is used to read data.  
  #
  # @attr [IO] output    
  #   The pipe which is used to write data.
  # 
  # @attr [Object] value
  #   The value read from a subprocess.
  #
  # @attr [Fixnum] pid
  #   The subprocess ID associated with this StreamPair.
  #
  # @api private
  # 
  class StreamPair < Struct.new(:variable, :input, :output, :value, :pid) 
  end

end
