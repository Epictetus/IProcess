describe 'warnings' do
  it 'should emit none' do
    Open3.popen3 "ruby -I lib -r'barney' -W -e ''" do |stdin, stdout, stderr| 
      warnings = stderr.read
      assert warnings.empty?, "Warnings: #{warnings}"
    end
  end
end
