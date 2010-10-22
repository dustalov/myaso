# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :development)

MG.new('myaso.gemspec')

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort 'RCov is not available. In order to run rcov, you must: ' \
          'sudo gem install rcov'
  end
end

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

task :default => :test
