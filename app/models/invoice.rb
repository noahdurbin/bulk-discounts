class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: %i[cancelled in_progress completed]

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def discounted_revenue
    revenue = 0
    invoice_items.each do |invoice_item|
      revenue += (invoice_item.discounted_price * invoice_item.quantity)
    end
    revenue.round(2)
  end

  def total_discount
    total_revenue.round(2) - discounted_revenue.round(2)
  end
end
