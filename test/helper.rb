# encoding: utf-8

require 'rubygems'
require 'test/unit'
require 'bundler/setup'
Bundler.require(:default, :development)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'myaso'

class Test::Unit::TestCase
end
