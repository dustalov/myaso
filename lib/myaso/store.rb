# encoding: utf-8

require 'moneta/adapters/tokyo_cabinet'
# Myaso Store.
#
class Myaso::Store
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
      filename = File.join(root, [ storage, 'tch' ].join('.'))
      moneta = Moneta::Adapters::TokyoCabinet.new(:file => filename,
        :mode => mode)

      ivar = "@#{storage}".to_sym
      instance_variable_set(ivar, moneta)
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