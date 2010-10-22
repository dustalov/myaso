# encoding: utf-8

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'myaso/version'
require 'rubygems'
require 'bundler/setup'
require 'active_support/core_ext'

# Myaso: The Morphological Analyzer.
#
class Myaso
  extend ActiveSupport::Autoload
  autoload :CLI
  autoload :Converter
  autoload :Inflector

  autoload :Model
end
