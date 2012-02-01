# encoding: utf-8

class Myaso::ActiveRecord::Prefix < ActiveRecord::Base
  def self.table_name
    'myaso_prefixes'
  end

  validates :prefix, presence: true
end
