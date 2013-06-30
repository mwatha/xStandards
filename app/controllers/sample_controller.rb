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

  def sampling
    @manufacturers = Manufacturer.order('name ASC').collect do |manu|
      [manu.name , manu.id]
    end

    @countries = Country.order('name ASC').collect do |country|
      [country.name , country.id]
    end

    @salt_types = SaltType.order('name ASC').collect do |salt|
      [salt.name , salt.id]
    end

  end

  def update_markets
    products = Market.where("district_id = ?",params[:id])
    @products = "<option id='Select brand name'>Select trading center</option>"
    (products || []).each do |product|
      @products += "<option value='#{product.id}'>#{product.name}</option>"
    end
    render :text => @products and return
  end

  def update_districts
    products = District.where("country_id = ?",params[:id])
    @products = "<option id='Select brand name'>Select district</option>"
    (products || []).each do |product|
      @products += "<option value='#{product.id}'>#{product.name}</option>"
    end
    render :text => @products and return
  end

  def update_borders
    products = Border.where("country_id = ?",params[:id])
    @products = "<option id='Select brand name'>Select entry point</option>"
    (products || []).each do |product|
      @products += "<option value='#{product.id}'>#{product.name}</option>"
    end
    render :text => @products and return
  end

  def create_industry_raw_data
    RawDataMarket.transaction do
      sample = RawDataMarket.new()
      sample.country_id = params[:sample]['country']
      sample.district_id = params[:sample]['district']
      sample.market_id = params[:sample]['market']
      sample.brand_name_id = params[:sample]['manufacturer']
      sample.salt_type_id = params[:sample]['salt_type']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date']
      if sample.save
        flash[:notice] = 'Successfully created.'                                
      else                                                                      
        flash[:error] = 'Something went wrong - did not create.'                
      end
    end

    redirect_to "/sampling" and return
  end

  def raw_data_quality_monitoring
    @manufacturers = Manufacturer.order('name ASC').collect do |manu|
      [manu.name , manu.id]
    end

    @countries = Country.order('name ASC').collect do |country|
      [country.name , country.id]
    end

    @salt_types = SaltType.order('name ASC').collect do |salt|
      [salt.name , salt.id]
    end

    @transporters = Transporter.order('name ASC').collect do |transporter|
      [transporter.name , transporter.id]
    end

  end

  def create_quality_monitoring_raw_data
    RawDataQualityMonitoring.transaction do
      sample = RawDataQualityMonitoring.new()
      sample.iir_code = params[:sample]['iir_code']
      sample.point_of_entry = params[:sample]['border']
      sample.importer_id = params[:sample]['importer']
      sample.salt_type_id = params[:sample]['salt_type']
      sample.country_id = params[:sample]['country']
      sample.volume_of_import = params[:sample]['volume']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date']
      if sample.save
        flash[:notice] = 'Successfully created.'                                
      else                                                                      
        flash[:error] = 'Something went wrong - did not create.'                
      end
    end

    redirect_to "/raw_data_quality_monitoring" and return
  end

end
