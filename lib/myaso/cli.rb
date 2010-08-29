# encoding: utf-8

class Myaso
  require 'thor'

  class CLI < Thor
    namespace :myaso
    map '-v' => :version

    desc 'convert STORAGE_PATH MORPHS GRAMTAB',
      'Convert aot.ru dictonaries into the TokyoCabinet'
    method_option :encoding, :type => :string, :default => 'utf8',
      :required => true
    def convert(storage_path, morphs, gramtab)
      converter = Myaso::Converter.new(storage_path, morphs,
        gramtab, options)
      converter.perform!
    end

    desc 'version', 'Print the myaso version'
    def version
      puts [ 'myaso', 'version', Myaso.version ].join(' ')
    end
  end
end
