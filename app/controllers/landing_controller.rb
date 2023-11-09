class LandingController < ApplicationController
  def index
    @merchants = Merchant.all
  end
end
