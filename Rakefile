task :default => :test

require 'rake/testtask'
desc 'Default: run unit tests.'
task :default => :test

Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb')
  test.libs << 'test'
  test.verbose = true
end
