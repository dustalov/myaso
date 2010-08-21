# encoding: utf-8

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'rubygems'
require 'active_support'
require 'active_support/core_ext'

class Myaso
  class << self
    # Return the root path of the <tt>Myaso</tt> gem.
    def root
      @myaso_root ||= File.expand_path('../../', __FILE__)
    end

    # Return the <tt>Myaso</tt> version according to
    # jeweler-defined <tt>VERSION</tt> file.
    def version
      @version ||= File.read(File.join(Myaso.root, 'VERSION')).chomp
    end
  end

  extend ActiveSupport::Autoload
  autoload :CLI
  autoload :Converter
  autoload :Inflector
end
