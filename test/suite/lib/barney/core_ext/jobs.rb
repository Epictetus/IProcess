describe '#Jobs' do

  it 'should spawn workers, and share their return value with the parent.' do
    result = Jobs(5) { 42 }
    assert_equal [42, 42, 42, 42, 42], result
  end


  it 'should have execute the passed block in the calling scope.' do
    number = 21
    result = Jobs(5) { number + number }
    assert_equal [42, 42, 42, 42, 42], result
  end

  it 'should return an array of arrays when an array is returned by a subprocess.' do
    result = Jobs(2) { [1] }
    assert_equal [[1], [1]], result
  end

end
