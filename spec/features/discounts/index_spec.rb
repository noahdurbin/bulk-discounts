require 'rails_helper'

RSpec.describe 'merchant discounts index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                           merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                           merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5,
                           merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: 'Hair tie', description: 'This holds up your hair', unit_price: 1,
                           merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: 'Scrunchie', description: 'This holds up your hair but is bigger', unit_price: 3,
                           merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: 'Butterfly Clip', description: 'This holds up your hair but in a clip', unit_price: 5,
                           merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: 'Bracelet', description: 'Wrist bling', unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: 'Necklace', description: 'Neck bling', unit_price: 300, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-27 14:54:09')
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-28 14:54:09')
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230_948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234_092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230_429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102_938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879_799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_7.id)

    @discount1 = @merchant1.discounts.create!(percentage: 0.1, quantity_threshold: 10)
    @discount2 = @merchant1.discounts.create!(percentage: 0.2, quantity_threshold: 20)
    @discount3 = @merchant1.discounts.create!(percentage: 0.3, quantity_threshold: 12)
    @discount4 = @merchant1.discounts.create!(percentage: 0.4, quantity_threshold: 15)
    @discount5 = @merchant2.discounts.create!(percentage: 0.1, quantity_threshold: 18)
  end

  it 'can show all discounts a merchant has' do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_content("#{@discount1.percent_off}% off #{@discount1.quantity_threshold} items or more")
    expect(page).to have_content("#{@discount2.percent_off}% off #{@discount2.quantity_threshold} items or more")
    expect(page).to have_content("#{@discount3.percent_off}% off #{@discount3.quantity_threshold} items or more")
    expect(page).to_not have_content("#{@discount4.percent_off}% off #{@discount5.quantity_threshold} items or more")
  end

  it 'has links to each discounts show page' do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link("Discount #{@merchant1.discounts.first.id}")
    expect(page).to have_link("Discount #{@merchant1.discounts.second.id}")
    expect(page).to have_link("Discount #{@merchant1.discounts.third.id}")
  end

  it 'has link to form to create a discount' do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link('Create New Discount')
  end

  it 'has a button by each discout to delete discount' do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_button('Delete Discount', count: 4)
  end

  it 'can delete a discount' do
    visit merchant_discounts_path(@merchant1)

    click_button "Delete Discount #{@merchant1.discounts.first.id}"

    expect(page).to have_button('Delete Discount', count: 3)

    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to_not have_content("Discount: #{@discount1.id}")
  end

  it 'give a flash message when a discount is deleted' do
    visit merchant_discounts_path(@merchant1)

    click_button "Delete Discount #{@merchant1.discounts.first.id}"

    expect(page).to have_content('Discount deleted')
  end
end
