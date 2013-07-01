class HomeController < ApplicationController
  def index
    @total_manufacturers = Manufacturer.count
    @total_borders = Border.count
    @total_markets = Market.count
  end
end
