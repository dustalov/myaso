# encoding: utf-8

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'rubygems'
require 'myaso/version'
require 'active_support/core_ext'
require 'shkuph'
require 'daemons'

# Myaso: The Morphological Analyzer.
#
class Myaso
  extend ActiveSupport::Autoload

  autoload :Constants

  autoload :Model
  autoload :Store

  autoload :CLI
  autoload :Converter
  autoload :Inflector
end
