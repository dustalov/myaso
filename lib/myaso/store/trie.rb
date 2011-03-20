# encoding: utf-8

class Myaso::Store::Trie
  include TokyoCabinet

  attr_reader :store

  def initialize(store)
    @store = store
  end

  def find(line)
    return nil if !line || line.empty?
    parent_id = nil

    line.each_char do |letter|
      found_parent_id = nil

      query(proc { |query|
        query.addcond('letter', TDBQRY::QCSTREQ, letter)
        if parent_id
          query.addcond('parent_id', TDBQRY::QCNUMEQ, parent_id)
        else
          query.addcond('parent_id',
            TDBQRY::QCSTRRX | TDBQRY::QCNEGATE, '^(.+)$')
        end
        query.setlimit(1, 0)
      }) { |found_id| found_parent_id = found_id }

      return nil unless found_parent_id
      parent_id = found_parent_id
    end

    parent_id
  end

  def retrieve(id)
    parent_id = id
    buf = ''

    while !parent_id.nil?
      record = store[parent_id]
      buf.insert(-1, record['letter'].force_encoding('utf-8'))
      parent_id = record['parent_id']
    end

    buf
  end

  private
    def query(query_setup, &block)
      TokyoCabinet::TDBQRY.new(store).
        tap(&query_setup).
        search.each(&block)
    end
end
