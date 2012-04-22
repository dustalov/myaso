# encoding: utf-8

# @private
class Myaso::ActiveRecord::Prefix < ActiveRecord::Base
  # @private
  def self.table_name
    'myaso_prefixes'
  end

  validates :prefix, presence: true
end
