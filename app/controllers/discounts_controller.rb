class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.create(create_params)

    if @discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = 'Discount not created: Required information missing.'
      redirect_to new_merchant_discount_path(@merchant)
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:notice] = 'Discount updated.'
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = 'Discount not updated: Required information missing.'
      redirect_to edit_merchant_discount_path(@merchant, @discount)
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    if discount.destroy
      redirect_to merchant_discounts_path(merchant)
      flash[:notice] = 'Discount deleted.'
    else
      flash[:notice] = 'Discount not deleted: Required information missing.'
      redirect_to merchant_discounts_path(merchant)
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:percentage, :quantity_threshold)
  end

  def create_params
    params.permit(:percentage, :quantity_threshold)
  end
end
