class ManufacturerController < ApplicationController
  def search
    @manufacturers = Manufacturer.order("name DESC")
  end

  def new
    @countries = Country.order('name ASC').collect do |country|                    
      [country.name , country.id]                                                   
    end 
  end

  def create
    Manufacturer.transaction do 
      manufacturer = Manufacturer.new()
      manufacturer.name = params[:manufacturer]['name']
      manufacturer.country_id = params[:manufacturer]['country']
      unless params[:manufacturer]['description'].blank?
        manufacturer.description = params[:manufacturer]['description']
      end
      if manufacturer.save                                                              
        flash[:notice] = 'Successfully created.'                                
      else                                                                      
        flash[:error] = 'Something went wrong - did not create.'                
      end                                                                       
    end                                                                         
    redirect_to '/newmanufacturer'
  end

end
