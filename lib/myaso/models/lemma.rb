# encoding: utf-8

# Myaso Lemma Model.
#
class Myaso::Model::Lemma < Sequel::Model(:lemmas)
  plugin :schema

  set_schema do
    primary_key :id
    integer :rule_id
    #foreign_key :rule_id, :rules
    varchar :base, :size => 64, :null => false,
      :index => true
  end

  many_to_one :rule, :primary_key => :rule_id

  create_table unless table_exists?
end
