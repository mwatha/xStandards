class SampleController < ApplicationController
  def search
    @samples = {}
    (Sample.all || []).each do |sample|
      @samples[sample.id] = {
        :batch_number => sample.batch_number,
        :product_name => sample.product.name,
        :manufacturer => sample.product.manufacturer.name,
        :iodine_level => sample.iodine_level,
        :category => sample.category,
        :date => sample.date.strftime('%d-%b-%Y')
      }
    end
  end

  def new
    @manufacturers = Manufacturer.order('name ASC').collect do |manu|
      [manu.name , manu.id]
    end

  end

  def update_products
    products = Product.where("manufacturer_id = ?",params[:id])
    @products = "<option id='Select brand name'>Select brand name</option>"
    (products || []).each do |product|
      @products += "<option value='#{product.id}'>#{product.name}</option>"
    end
    render :text => @products and return
  end

  def create
    Sample.transaction do
      sample = Sample.new()
      sample.batch_number = params[:sample]['batch_num']
      sample.product_id = params[:sample]['product']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date']
      if sample.save
        flash[:notice] = 'Successfully created.'                                
      else                                                                      
        flash[:error] = 'Something went wrong - did not create.'                
      end
    end

    redirect_to "/newsample" and return
  end

end
