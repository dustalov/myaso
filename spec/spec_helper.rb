# encoding: utf-8

require 'rubygems'

$:.unshift File.expand_path('../../lib', __FILE__)

require 'myaso'

if RUBY_VERSION == '1.8'
  gem 'minitest'
end

require 'fileutils'
require 'tmpdir'

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
