class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])

    if params[:discount].to_f == 0.0 || params[:min_qty].to_i == 0
      # use flash.now[:alert] when rendering, as it will not carry over to the next request
      flash.now[:alert] = "Invalid Inputs: ensure discount is a decimal and minimum quantity is a whole number"
      render :new
    else
      @merchant
        .bulk_discounts
        .create!(discount: params[:discount],
          min_qty: params[:min_qty])

      redirect_to merchant_discounts_path(@merchant)
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])

    BulkDiscount.delete(params[:id])

    redirect_to merchant_discounts_path(@merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    if discount_params[:discount].to_f == 0.0 || discount_params[:min_qty].to_i == 0
      # use flash.now[:alert] when rendering, as it will not carry over to the next request
      flash.now[:alert] = "Invalid Inputs: ensure discount is a decimal and minimum quantity is a whole number"
      render :edit
    else
      @discount.update!(discount_params)

      redirect_to merchant_discount_path(@merchant, @discount)
    end
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:discount, :min_qty)
  end
end
