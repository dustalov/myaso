# encoding: utf-8

require 'tokyocabinet'
include TokyoCabinet

require 'yajl'

# Duck Punch of TokyoCabinet Hash database that uses JSON over Yajl
# to serialize Ruby objects. Serialization necessary since TC expects
# values as strings or integers so won't handle other data types.
# Also provides a consistent, simpler open method.
#
# This implementation is based on article:
# http://blog.henriquez.net/2009/07/tokyo-cabinet-and-me.html
class TokyoCabinet::HDB
  # initialize db and return handle to db. There is one db file per
  # data structure, e.g. new hash means new database and database file
  # so call init again. Creates db file if it doesn't already exist.
  alias :original_open :open
  def open(path_to_db)
    unless self.original_open(path_to_db, HDB::OWRITER | HDB::OCREAT)
      raise "#{path_to_db} error: #{self.errmsg(self.ecode)}"
    end
  end

  alias original_get_brackets []
  def [](key)
    result = self.original_get_brackets(key)
    result ? Yajl::Parser.parse(result) : nil
  end

  alias original_set_brackets []=
  def []=(key, value)
    self.original_set_brackets(key, Yajl::Encoder.encode(value))
  end

  alias original_each each
  def each
    self.original_each { |k, v| yield(k, Yajl::Parser.parse(v)) }
  end
end
