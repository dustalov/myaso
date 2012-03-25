# encoding: utf-8

class Myaso::ActiveRecord::Word < ActiveRecord::Base
  def self.table_name
    'myaso_words'
  end

  belongs_to :stem, class_name: '::Myaso::ActiveRecord::Stem',
    :inverse_of => :words
  belongs_to :rule, class_name: '::Myaso::ActiveRecord::Rule',
    :inverse_of => :words

  validates :stem, presence: true, associated: true
  validates :rule, associated: true
end
