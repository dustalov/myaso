# encoding: utf-8

require 'thor'
require 'daemons'
require 'pp'

# Myaso Command-Line Interface based on the awesome Thor library.
#
class Myaso::CLI < Thor
  namespace :myaso
  map '-v' => :version

  desc 'convert STORAGE_PATH MORPHS GRAMTAB',
    'Convert aot.ru dictonaries into the GDBM database'
  method_option :encoding, :type => :string, :default => 'utf8',
    :required => true
  method_option :daemonize, :type => :boolean, :default => false
  def convert(storage_path, morphs, gramtab) # :nodoc:
    raise NotImplementedError if options[:daemonize]
    converter = Myaso::Converter.new(storage_path, morphs,
      gramtab, options)
    converter.perform!
  end

  desc 'predict WORD', 'Perform the word morphology prediction'
  method_option :store, :type => :string, :required => true
  def predict(word) # :nodoc:
    raise ArgumentError unless word && !word.empty?

    store = Myaso::Store.new(options[:store])
    morph = Myaso::Morphology.new(store)
    pp morph.predict(word)
  end

  desc 'version', 'Print the myaso version'
  def version # :nodoc:
    puts [ 'myaso', 'version', Myaso::Version ].join(' ')
  end

  desc 'irb', 'Start the IRB Session in the Myaso'
  def irb # :nodoc:
    require 'myaso/core_ext/irb'
    IRB.start_session(binding)
  end
end
