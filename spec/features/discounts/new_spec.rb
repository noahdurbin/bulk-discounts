require 'rails_helper'

RSpec.describe 'discounts new page' do
  before :each do
    @merchant = Merchant.create!(name: 'Merchant 1')
  end

  it 'can create a new discount' do
    visit new_merchant_discount_path(@merchant)

    fill_in 'Percentage', with: 23
    fill_in 'Quantity Threshold', with: 17

    click_button 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path(@merchant))
    expect(page).to have_content('23.0% off 17 items or more')
  end

  it 'cannot create a discount without required information' do
    visit new_merchant_discount_path(@merchant)

    fill_in 'Percentage', with: 0.23

    click_button 'Create Discount'

    expect(page).to have_content('Discount not created: Required information missing.')
    expect(current_path).to eq(new_merchant_discount_path(@merchant))
  end
end
