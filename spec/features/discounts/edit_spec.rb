require 'rails_helper'

RSpec.describe 'discount edit page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = @merchant1.discounts.create!(percentage: 0.1, quantity_threshold: 10)
  end

  describe 'as a merchant' do
    it 'it sees a form with attributes already filled in' do
      visit edit_merchant_discount_path(@merchant1, @discount1)

      expect(page).to have_field('Percentage', with: '10.0')
      expect(page).to have_field('Quantity threshold', with: '10')
    end

    it 'can edit a discounts attributes' do
      visit edit_merchant_discount_path(@merchant1, @discount1)

      fill_in 'Percentage', with: '0.2'
      fill_in 'Quantity threshold', with: '20'

      click_button 'Submit'

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
      expect(page).to have_content('20.0% off')
      expect(page).to have_content('20 items or more')
    end
  end
end
