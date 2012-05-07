# encoding: utf-8

# Interface to Tokyo Cabinet Table Database.
#
class Myaso::TokyoCabinet < Myaso::Base
  include ::TokyoCabinet

  # A list of storages. Each storage is a separate database file.
  #
  STORAGES = [ :prefixes, :stems, :rules, :words ]

  attr_reader :path, :mode, :storages

  # Create a new instance of Database that is located at the specified
  # `path`. Also you may pass `:manage` option to the `mode` argument
  # and achieve a blocking, but monopoly access to database internals.
  #
  # Please #close! the database after use.
  #
  # @param path [String] a path to the database directory.
  # @param mode [:read, :manage] a database access mode.
  #
  def initialize(path, mode = :read)
    @path, @mode, @storages = path, mode, {}

    # we can manage our database (full monopoly access) or just read it
    store_mode = if :manage == mode
      TDB::OWRITER | TDB::OCREAT
    else
      TDB::OREADER
    end

    # initialize all storages in common manner
    STORAGES.each do |storage_name|
      filename = File.join(path, '%s.tct' % storage_name)

      # open our database in defined mode
      storage = TDB.new
      unless storage.open(filename, store_mode)
        raise storage.errmsg(storage.ecode)
      end

      # Let there be more Unicode (actually, this solution is full of shit)
      storage.class.class_eval { alias_method :cget, :get }

      # @private
      def storage.[] *args
        (r = cget(*args)) && r.each { |_, v| v.force_encoding 'UTF-8' }
      end

      # @private
      def storage.get *args
        (r = cget(*args)) && r.each { |_, v| v.force_encoding 'UTF-8' }
      end

      # Tokyo Cabinet Extension has strange issues with
      # DB#each method functionality, let's fix it.

      # @private
      def storage.each(&block)
        return [] unless iterinit
        while (key = iternext)
          block.call(key)
        end
      end

      storages[storage_name] = storage
    end

    storages.freeze

    super()
  end

  # @private
  def inspect
    "\#<#{self.class.name} path=\"#{path}\" mode=:#{mode}>"
  end

  # Perform a complete reindexing of this database. You should
  # `:manage` this database to use this method.
  #
  # @return [nil] nothing.
  #
  def reindex!
    unless :manage == mode
      raise 'You need to :manage this database to reindex it!'
    end

    # prefixes index
    storages[:prefixes].setindex 'prefix', TDB::ITLEXICAL

    # stems index
    storages[:stems].setindex 'msd', TDB::ITLEXICAL
    storages[:stems].setindex 'rule_set_id', TDB::ITDECIMAL
    storages[:stems].setindex 'stem', TDB::ITLEXICAL

    # rules index
    storages[:rules].setindex 'msd', TDB::ITLEXICAL
    storages[:rules].setindex 'rule_set_id', TDB::ITDECIMAL
    storages[:rules].setindex 'prefix', TDB::ITLEXICAL
    storages[:rules].setindex 'suffix', TDB::ITLEXICAL

    # words index
    storages[:words].setindex 'stem_id', TDB::ITDECIMAL
    storages[:words].setindex 'rule_id', TDB::ITDECIMAL

    nil
  end

  # Is our database closed?
  #
  # @return [true, false] a state of database.
  #
  def closed?
    storages.inject(true) do |r, (_, storage)|
      r && storage.path.nil?
    end
  end

  # Set our database free.
  #
  # @return [nil] nothing.
  #
  def close!
    storages.each_value(&:close) and @storages = {}
    nil
  end
end

require 'myaso/tokyo_cabinet/prefixes'
require 'myaso/tokyo_cabinet/rules'
require 'myaso/tokyo_cabinet/stems'
require 'myaso/tokyo_cabinet/words'
