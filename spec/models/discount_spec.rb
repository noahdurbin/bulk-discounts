require 'rails_helper'

describe Discount do
  describe 'validations' do
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity_threshold }
    it { should validate_numericality_of :percentage }
    it { should validate_numericality_of :quantity_threshold }
    it { should validate_numericality_of(:percentage).is_greater_than(0).is_less_than_or_equal_to(1) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
end
