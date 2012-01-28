# encoding: utf-8

$:.unshift File.expand_path('../../lib', __FILE__)

require 'myaso'

if RUBY_VERSION == '1.8'
  gem 'minitest'
end

require 'minitest/autorun'
