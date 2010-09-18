# encoding: utf-8

class Myaso::Model::Lemma < Sequel::Model(:lemmas)
  plugin :schema

  set_schema do
    primary_key :id
    foreign_key :rule_id, :rules
    varchar :base, :size => 128, :null => false,
      :index => true, :unique => true
  end

  create_table unless table_exists?
end
