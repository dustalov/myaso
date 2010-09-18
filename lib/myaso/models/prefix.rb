# encoding: utf-8

class Myaso::Model::Prefix < Sequel::Model
  plugin :schema

  set_schema do
    primary_key :id
    varchar :line, :size => 128, :null => false
  end

  create_table unless table_exists?
end
