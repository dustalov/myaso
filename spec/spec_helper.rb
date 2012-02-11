# encoding: utf-8

require 'rubygems'

$:.unshift File.expand_path('../../lib', __FILE__)

require 'myaso'

if RUBY_VERSION == '1.8'
  gem 'minitest'
end

require 'fileutils'
require 'tmpdir'

unless 'true' == ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'minitest/autorun'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
