# encoding: utf-8

require 'rubygems'

$:.unshift File.expand_path('../../lib', __FILE__)

require 'tokyocabinet'
require 'active_record'

if RUBY_VERSION == '1.8'
  gem 'minitest'
end

require 'minitest/autorun'

require 'fileutils'
require 'tmpdir'

unless 'true' == ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'myaso'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
