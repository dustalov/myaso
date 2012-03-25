#!/usr/bin/env rake
# encoding: utf-8

require 'bundler/gem_tasks'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'reek/rake/task'

  Reek::Rake::Task.new do |reek|
    reek.fail_on_error = false
  end
rescue LoadError
  # okay
end
