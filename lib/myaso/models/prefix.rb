# encoding: utf-8

# Myaso Word Prefix Model.
#
class Myaso::Model::Prefix < Sequel::Model
  plugin :schema

  set_schema do
    primary_key :id
    varchar :line, :size => 32, :null => false
  end

  create_table unless table_exists?
end
