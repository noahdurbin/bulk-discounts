class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: %i[pending packaged shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where('status = 0 OR status = 1').pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discounted_price
    discount = applied_discount

    if discount
      unit_price * (1 - discount.percentage)
    else
      unit_price
    end
  end

  def applied_discount
    discount = item.merchant.discounts
                   .where('quantity_threshold <= ?', quantity)
                   .order(percentage: :desc)
                   .first
  end
end
