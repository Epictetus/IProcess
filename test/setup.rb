require('riot')
require('barney')
Dir.glob("test/suite/lib/**/*.rb").each do |test|
  require(test)
end

