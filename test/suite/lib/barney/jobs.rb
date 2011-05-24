describe '#Jobs' do

  it 'should spawn workers, and return their return value in an array' do
    result = Jobs(5) { 42 }
    assert_equal [42, 42, 42, 42, 42], result
  end


end
