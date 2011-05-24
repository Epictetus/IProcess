def Jobs number, &block
  barney = Barney::Share.new
  barney.share :queue
  queue = []

  number.times do
    barney.fork do
      queue << block.call
    end
  end

  barney.wait_all
  barney.sync

  barney.history.map(&:value).flatten
end
 
