require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'myaso'
    gem.executables = 'myaso'
    gem.summary = %Q{tasty myaso}
    gem.description = %Q{myaso: nice morphological analyzer}
    gem.email = "dmitry@eveel.ru"
    gem.homepage = "http://suckless.ru/"
    gem.authors = ["Dmitry A. Ustalov"]
    gem.add_development_dependency 'yard', '>= 0.5.0'
    gem.add_development_dependency 'shoulda', '>= 0'
    gem.add_dependency 'activesupport', '>= 3.0.0.RC'
    gem.add_dependency 'i18n', '>= 0.4.0'
    gem.add_dependency 'thor', '>= 0.14.0'
    gem.add_dependency 'yajl-ruby', '>= 0.7.0'
    gem.add_dependency 'tokyocabinet', '>= 1.20'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

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
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
  #  t.options = ['--any', '--extra', '--opts']
  end
rescue LoadError
  task :yard do
    abort 'YARD is not available. In order to run yard, you must: gem install yard'
  end
end
