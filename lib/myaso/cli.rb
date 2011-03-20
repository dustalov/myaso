# encoding: utf-8

require 'thor'
require 'pp'

# Myaso Command-Line Interface based on
# the awesome Thor library.
#
class Myaso::CLI < Thor
  namespace :myaso
  map '-v' => :version

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
    require 'myaso/cli/irb'
    IRB.start_session(binding)
  end
end
