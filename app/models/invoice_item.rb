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
    discount = item.merchant.discounts
                   .select('percentage')
                   .where('quantity_threshold <= ?', quantity)
                   .order(percentage: :desc)
                   .limit(1)
                   .pick(:percentage)

    if discount
      (unit_price * (1 - percentage)).round(2)
    else
      unit_price
    end
  end
end
