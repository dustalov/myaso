#!/usr/bin/env rake
# encoding: utf-8

require 'bundler/gem_tasks'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end
