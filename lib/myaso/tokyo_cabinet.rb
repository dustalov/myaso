# encoding: utf-8

class Myaso::TokyoCabinet
  include Myaso::Client
  include ::TokyoCabinet

  STORAGES = [ :prefixes, :stems, :rules, :words ] # :nodoc:
  attr_reader :path, :mode, :storages

  # Create a new instance of Database that is located at
  # specified +path+. Also you may pass <tt>:manage</tt>
  # option to the +mode+ argument and achieve a blocking,
  # but total access to database internals.
  #
  # Please #close! the database after use.
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
      storage.class.class_eval do
        alias_method :cget, :get
      end

      def storage.[] *args
        (r = cget(*args)) && r.each { |_, v| v.force_encoding 'UTF-8' }
      end

      def storage.get *args
        (r = cget(*args)) && r.each { |_, v| v.force_encoding 'UTF-8' }
      end

      # Tokyo Cabinet Extension has strange issues with
      # DB#each method functionality, let's fix it.
      def storage.each(&block) # :nodoc:
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

  def inspect # :nodoc:
    "\#<#{self.class.name} path=\"#{path}\" mode=:#{mode}>"
  end

  # Perform a complete reindexing of this database. You should
  # <tt>:manage</tt> this database to use this method.
  #
  def reindex!
    unless :manage == mode
      raise 'You need to :manage this database to reindex it!'
    end

    # # morphosyntactic descriptors index
    # storages[:msds].setindex 'pos', TDB::ITLEXICAL

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
  def closed?
    storages.inject(true) do |r, (_, storage)|
      r && storage.path.nil?
    end
  end

  # Set our database free.
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
