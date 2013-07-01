class CountryController < ApplicationController
  def index
  end

  def createcountry
    country = Country.new()                                                       
    country.name = params[:country]['name']
    unless params[:country]['description'].blank?                                                           
      country.description = params[:country]['description']
    end
    if country.save
      flash[:notice] = 'Successfully created.'                                
    else
      flash[:error] = 'Something went wrong - did not create.'                
    end

    redirect_to '/newcountry'
  end

  def createdistrict
    District.transaction do
      district = District.new()                                                       
      district.name = params[:district]['name']
      district.country_id = params[:district]['country']
      unless params[:district]['description'].blank?                                                           
        district.description = params[:district]['description']
      end
      if district.save
        flash[:notice] = 'Successfully created.'                                
      else
        flash[:error] = 'Something went wrong - did not create.'                
      end
    end
    redirect_to '/newdistrict'
  end

  def createborder
    Border.transaction do
      border = Border.new()                                                       
      border.name = params[:border]['name']
      border.country_id = params[:border]['country']
      unless params[:border]['description'].blank?                                                           
        border.description = params[:border]['description']
      end
      if border.save
        flash[:notice] = 'Successfully created.'                                
      else
        flash[:error] = 'Something went wrong - did not create.'                
      end
    end
    redirect_to '/newborder'
  end

  def createmarket
    Market.transaction do
      market = Market.new()                                                       
      market.name = params[:market]['name']
      market.district_id = params[:market]['district']
      unless params[:market]['description'].blank?                                                           
        market.description = params[:market]['description']
      end
      if market.save
        flash[:notice] = 'Successfully created.'                                
      else
        flash[:error] = 'Something went wrong - did not create.'                
      end
    end
    redirect_to '/newmarket'
  end
  
  def newborder
    @countries = Country.order('name ASC').collect do |country|                    
      [country.name , country.id]                                                   
    end 
  end

  def newmarket
    @districts = District.order('name ASC').collect do |district|                    
      [district.name , district.id]                                                   
    end 
  end

  def newdistrict
    @countries = Country.order('name ASC').collect do |country|                    
      [country.name , country.id]                                                   
    end 
  end

  def findborders
    @borders = {}
    (Border.order('name') || []).each do |border|
      @borders[border.id] = {
        :country => border.country.name,
        :name => border.name,
        :description => border.description
      }
    end
  end

  def findmarkets
    @markets = {}
    (Market.order('name') || []).each do |market|
      @markets[market.id] = {
        :name => market.name,
        :district => market.district.name,
        :country => market.district.country.name,
        :description => market.description
      }
    end
  end

  def findcountries
    @countries = {}
    (Country.order('name') || []).each do |country|
      @countries[country.id] = {
        :name => country.name,
        :description => country.description
      }
    end
  end

end
