# encoding: utf-8

require 'rubygems'

gem 'minitest'
require 'minitest/autorun'
require 'minitest/hell'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'myaso'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
