# encoding: utf-8

class Myaso::ActiveRecord::Rule < ActiveRecord::Base
  def self.table_name
    'myaso_rules'
  end

  has_many :words, class_name: '::Myaso::ActiveRecord::Word',
    :inverse_of => :rule

  validates :rule_set_id, presence: true
  validates :msd, presence: true
end
