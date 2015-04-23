require 'bundler/gem_tasks'
# remove release task
Rake::Task["release"].clear

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  puts 'rspec tasks could not be loaded'
end
