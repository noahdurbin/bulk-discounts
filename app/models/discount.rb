class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percentage
  validates_presence_of :quantity_threshold
  validates_numericality_of :percentage
  validates_numericality_of :quantity_threshold
end
