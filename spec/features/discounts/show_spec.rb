require 'rails_helper'

RSpec.describe 'discount show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = @merchant1.discounts.create!(percentage: 0.1, quantity_threshold: 10)
  end

  describe 'as a merchant' do
    it 'displays a discounts ID' do
      visit merchant_discount_path(@merchant1, @discount1)

      expect(page).to have_content("Discount #{@discount1.id}")
    end

    it 'displays a discounts percentage off' do
      visit merchant_discount_path(@merchant1, @discount1)

      expect(page).to have_content('10.0% off')
    end

    it 'displays a discounts item threshold for a discount' do
      visit merchant_discount_path(@merchant1, @discount1)
      save_and_open_page
      expect(page).to have_content('10 items or more')
    end
  end
end
