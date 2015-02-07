#!/usr/bin/env rake
# encoding: utf-8

require 'rubygems/package_task'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

task :default => :test

Rake::TestTask.new do |test|
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.main = "README.md"
  rdoc.rdoc_files.include('README.md', 'CHANGES.md', 'LICENSE.txt', 'lib/**/*.rb')
end
