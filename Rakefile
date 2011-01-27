# encoding: utf-8

require 'bundler/setup'
Bundler.require(:default, :development)

require 'rspec/core/rake_task'
desc 'Run all examples'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

Bundler::GemHelper.install_tasks

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files = [ 'lib/**/*.rb' ]
  end
rescue LoadError
  task :yard do
    abort 'YARD is not available. In order to run yard, you must: ' \
          'gem install yard'
  end
end

task :default => :spec
