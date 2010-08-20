# encoding: utf-8

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'rubygems'
require 'active_support'
require 'active_support/core_ext'

class Myaso
  class << self
    def root
      @myaso_root ||= File.expand_path('../../', __FILE__)
    end

    def version
      @version ||= File.read(File.join(Myaso.root, 'VERSION')).chomp
    end
  end

  autoload :Inflector, File.join(Myaso.root, 'lib', 'myaso', 'inflector')
end
