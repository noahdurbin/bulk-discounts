class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.create(discount_params)

    if @discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = 'Discount not created: Required information missing.'
      redirect_to new_merchant_discount_path(@merchant)
    end
  end

  private

  def discount_params
    params.permit(:percentage, :quantity_threshold)
  end
end
