require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs = ['lib','test']
  t.test_files = FileList["test/**/*_test.rb"].exclude(/integration/)
  t.verbose = true
end

namespace :test do
  Rake::TestTask.new('integration') do |t|
    t.libs = ['lib','test']
    t.test_files = FileList['integration/**/*_test.rb']
    t.verbose = true
  end
end

task :default => :test
