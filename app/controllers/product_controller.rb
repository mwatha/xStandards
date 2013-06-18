class ProductController < ApplicationController
  def search
    @products = {}
    Product.order("name DESC").collect do |product|
      @products[product.id] = {:name => product.name, :manufacturer => product.manufacturer.name,
       :product_id => product.id,:description => product.description,
       :date_registered => product.created_at
      }
    end
  end

  def new
    @manufacturers = Manufacturer.order('name ASC').collect do |manufacturer|                    
      [manufacturer.name , manufacturer.id]                                                   
    end 
  end

  def create
    Product.transaction do 
      product = Product.new()
      product.name = params[:product]['name']
      product.manufacturer_id = params[:product]['manufacturer']
      unless params[:product]['description'].blank?
        product.description = params[:product]['description']
      end
      if product.save                                                              
        flash[:notice] = 'Successfully created.'                                
      else                                                                      
        flash[:error] = 'Something went wrong - did not create.'                
      end                                                                       
    end                                                                         
    redirect_to '/newproduct'
  end

end
