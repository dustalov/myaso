# encoding: utf-8

class Myaso::Model::Rule < Sequel::Model(:rules)
  plugin :schema

  set_schema do
    primary_key :id
    integer :rule_id, :null => false
    varchar :suffix, :size => 32, :null => false
    varchar :ancode, :size => 6, :null => false
    varchar :prefix, :size => 32
    integer :freq, :null => false, :default => 0
  end

  one_to_many :lemma, :primary_key => :rule_id

  create_table unless table_exists?
end
