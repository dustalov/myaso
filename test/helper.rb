# encoding: utf-8

require 'test/unit'

$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.dirname(__FILE__)

require 'myaso'

Bundler.require(:default, :development)

class Test::Unit::TestCase
end
