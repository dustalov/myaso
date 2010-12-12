# encoding: utf-8

require 'myaso/version'
require 'active_support/core_ext'

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

  autoload :Morphology
end
