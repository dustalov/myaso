# encoding: utf-8

require 'shkuph'
require 'shkuph/strategies/string_strategy'
require 'shkuph/strategies/marshal_strategy'
require 'shkuph/adapters/gdbm'

# Myaso Store.
#
class Myaso::Store
  # Myaso Key Strategy for Shkuph.
  KEY_STRATEGY = Shkuph::StringStrategy.new
  VALUE_STRATEGY = Shkuph::MarshalStrategy.new

  # List of suitable storages for Myaso.
  STORAGES = [ :flexias, :lemmas, :ancodes, :prefixes, :endings ]
  STORAGES.each { |s| attr_reader(s) }

  # Create a new instance of the Myaso::Store class.
  #
  # ==== Parameters
  # root<String>:: Root directory of the Myaso data storage.
  # mode<Symbol>:: Access mode: `:read` to read or anything
  #                else to manage.
  #
  def initialize(root, mode = nil)
    STORAGES.each do |storage|
      filename = File.join(root, [ storage, 'gdbm' ].join('.'))

      shkuph = Shkuph::Adapters::GDBM.new(filename, mode,
        KEY_STRATEGY, VALUE_STRATEGY)

      ivar = "@#{storage}".to_sym
      instance_variable_set(ivar, shkuph)
    end
  end

  # Close all the Myaso storages.
  #
  def close
    STORAGES.each do |storage|
      self.send(storage).close
    end
    nil
  end

  private
end