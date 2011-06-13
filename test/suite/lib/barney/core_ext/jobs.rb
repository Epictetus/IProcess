describe '#Jobs' do

  it 'should spawn workers, and share their return value with the parent.' do
    result = Jobs(5) { 42 }
    assert_equal [42, 42, 42, 42, 42], result
  end


end
