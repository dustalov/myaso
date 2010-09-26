# encoding: utf-8

require 'thor'

# Myaso Command-Line Interface based on the awesome Thor library.
#
class Myaso::CLI < Thor
  namespace :myaso
  map '-v' => :version

  desc 'convert STORAGE_PATH MORPHS GRAMTAB',
    'Convert aot.ru dictonaries into the SQLite3 database'
  method_option :encoding, :type => :string, :default => 'utf8',
    :required => true
    def convert(storage_path, morphs, gramtab) # :nodoc:
    converter = Myaso::Converter.new(storage_path, morphs,
      gramtab, options)
    converter.perform!
  end

  desc 'version', 'Print the myaso version'
  def version # :nodoc:
    puts [ 'myaso', 'version', Myaso.version ].join(' ')
  end
end
