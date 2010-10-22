# encoding: utf-8

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'rubygems'
require 'bundler/setup'
require 'active_support/core_ext'

# Myaso: The Morphological Analyzer.
#
class Myaso
  class << self
    # Root path of the Myaso gem.
    #
    # ==== Returns
    # String:: Myaso root path.
    #
    def root
      @@myaso_root ||= File.expand_path('../../', __FILE__)
    end
    
    # Myaso gem version according to jeweler-defined
    # VERSION file.
    #
    # ==== Returns
    # String:: Myaso semantic version.
    #
    def version
      @@version ||= File.read(File.join(Myaso.root, 'VERSION')).chomp
    end
  end

  extend ActiveSupport::Autoload
  autoload :CLI
  autoload :Converter
  autoload :Inflector

  autoload :Model
end
