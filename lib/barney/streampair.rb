#
# @attr [Symbol] variable 
#   The name of the variable associated with _in_, and _out_.
#
# @attr [IO] in       
#   The pipe which is used to read data.  
#
# @attr [IO] out      
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
class Barney::StreamPair < Struct.new(:variable, :in, :out, :value, :pid) 
end
