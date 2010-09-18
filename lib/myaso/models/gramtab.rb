# encoding: utf-8

class Myaso::Model::Gramtab < Sequel::Model(:gramtabs)
  plugin :schema

  set_schema do
    primary_key :id
    varchar :ancode, :size => 128, :null => false,
      :index => true, :unique => true
    varchar :letter, :size => 128, :null => false
    varchar :kind, :size => 128, :null => false
    varchar :info, :size => 128
  end

  create_table unless table_exists?
end
