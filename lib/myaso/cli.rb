# encoding: utf-8

class Myaso
  require 'thor'

  class CLI < Thor
    namespace :myaso
    map '-v' => :version

    desc 'convert TCH_PATH',
      'Convert aot.ru dictonaries into the TokyoTable'
    method_option :encoding, :type => :string, :default => 'utf8',
      :required => true
    method_option :morphs, :type => :string, :required => true
    method_option :gramtab, :type => :string, :required => true
    def convert(tch_path)
      converter = Myaso::Converter.new(tch_path, options)
      converter.perform!
    end

    desc 'version', 'Print the myaso version'
    def version
      puts [ 'myaso', 'version', Myaso.version ].join(' ')
    end
  end
end
