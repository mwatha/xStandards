class SampleController < ApplicationController

  def edit_market
    if request.post?
      sample = RawDataMarket.where(:id => params[:sample_id])[0]
      sample.county_id = County.where(:name => params[:county])[0].id
      sample.sub_county_id = SubCounty.where(:name => params[:subcounty])[0].id
      sample.market_id = Market.where(:name => params[:market])[0].id
      sample.manufacturer_id = Manufacturer.where(:name => params[:manufacturer])[0].id
      sample.salt_brand_id = Product.where(:name => params['salt_brand'])[0].id
      sample.iodine_level = params[:input]['iodine_level']
      sample.category = get_category(params[:input]['iodine_level'].to_f)
      sample.date = params[:input]['date0']
      sample.save
      redirect_to "/find_raw_data_market_control" and return
    end

    sample = RawDataMarket.where(:id => params[:id])[0]
    @sample = {
      :county => sample.county.name,
      :id => sample.id,
      :subcounty => sample.sub_county.name,
      :market => sample.market.name,
      :manufacturer => sample.manufacturer.name,
      :salt_brand => sample.salt_brand.name,
      :quater => quater(sample.date),
      :iodine_level => sample.iodine_level,
      :category => sample.category,
      :date => sample.date.strftime('%d-%b-%Y')
    }

    @manufacturers = Manufacturer.order('name ASC').collect do |manu|
      [manu.name , manu.name]
    end

    @salt_brands = Product.order('name ASC').collect do |product|
      [product.name , product.name]
    end

    @subcounties = SubCounty.order('name ASC').collect do |sub_county|
      [sub_county.name , sub_county.name]
    end

    @counties = County.order('name ASC').collect do |county|
      [county.name , county.name]
    end

    @markets = Market.order('name ASC').collect do |market|
      [market.name , market.name]
    end

  end
  #.....................................................................................................................

  def edit_industry
    if request.post?
      sample = IndustryRawData.where(:id => params['sample_id'])[0]
      sample.cis_code = params[:input]['cis_code']
      sample.country_id = Country.where(:name => params['country'])[0].id
      sample.salt_brand_id = Product.where(:name => params['salt_brand'])[0].id
      sample.iodine_level = params[:input]['iodine_level']
      sample.category = get_category(params[:input]['iodine_level'].to_f)
      sample.date = params[:input]['date0']
      sample.save
      redirect_to "/find_raw_data_industry_monitoring" and return
    end
 
    sample = IndustryRawData.where(:id => params[:id])[0]
    @sample = {
      :cis_code => sample.cis_code,
      :country => sample.country.name,
      :salt_brand => sample.salt_brand.name,
      :iodine_level => sample.iodine_level,
      :category => sample.category,
      :other => sample.other,
      :date => sample.date.strftime('%d-%m-%Y'),
      :id => sample.id
    }

    @manufacturers = Manufacturer.order('name ASC').collect do |manu|
      [manu.name , manu.name]
    end

    @salt_brands = Product.order('name ASC').collect do |product|
      [product.name , product.name]
    end

    @countries = Country.order('name ASC').collect do |country|
      [country.name , country.name]
    end

  end

  #.....................................................................................................................


  def delete_entered_data
    if params[:cmd] == 'import'
      RawDataQualityMonitoring.delete(params[:id])
      redirect_to "/import_monitoring"
    elsif params[:cmd] == 'industry'
      IndustryRawData.delete(params[:id])
      redirect_to "/find_raw_data_industry_monitoring"
    elsif params[:cmd] == 'market'
      RawDataMarket.delete(params[:id])
      redirect_to "/find_raw_data_market_control"
    end
    return
  end

  def edit_import
    if request.post?
      sample = RawDataQualityMonitoring.where(:id => params['sample_id'])[0]
      sample.iir_code = params[:input]['iir_code']
      sample.country_id = Country.where(:name => params['country'])[0].id
      sample.border_id = Border.where(:name => params['border'])[0].id
      sample.salt_brand_id = Product.where(:name => params['salt_brand'])[0].id
      sample.iodine_level = params[:input]['iodine_level']
      sample.category = get_category(params[:input]['iodine_level'].to_f)
      sample.volume_of_import = params[:input]['volume']
      sample.date = params[:input]['date0']
      sample.importer_id = Transporter.where(:name => params['transporter'])[0].id
      sample.save
      redirect_to "/import_monitoring" and return
    end
 
    sample = RawDataQualityMonitoring.where(:id => params[:id])[0]
    @sample = {
      :iir_code => sample.iir_code,
      :country => sample.country.name,
      :importer => sample.importer.name,
      :salt_brand => sample.salt_brand.name,
      :iodine_level => sample.iodine_level,
      :category => sample.category,
      :border => sample.point_of_entry.name,
      :volume => sample.volume_of_import,
      :date => sample.date.strftime('%d-%m-%Y'),
      :quarter => quater(sample.date),
      :id => sample.id
    }

    @manufacturers = Manufacturer.order('name ASC').collect do |manu|
      [manu.name , manu.id]
    end

    @countries = Country.order('name ASC').collect do |country|
      [country.name , country.name]
    end

    @salt_brands = Product.order('name ASC').collect do |product|
      [product.name , product.name]
    end

    @transporters = Transporter.order('name ASC').collect do |transporter|
      [transporter.name , transporter.name]
    end

    @borders = Border.order('name ASC').collect do |border|                 
      [border.name , border.name]                                               
    end                                                                         
                                                                                
  end

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

  def find_raw_data_market_control
    @samples = {}
    (RawDataMarket.order("created_at DESC").limit(100) || []).each do |sample|
      @samples[sample.id] = {
        :county => sample.county.name,
        :subcounty => sample.sub_county.name,
        :market => sample.market.name,
        :manufacturer => sample.manufacturer.name,
        :salt_brand => sample.salt_brand.name,
        :quater => quater(sample.date),
        :iodine_level => sample.iodine_level,
        :category => sample.category,
        :date => sample.date.strftime('%d-%b-%Y')
      }
    end

    @markets = Market.order('name ASC').collect do |market|
      [market.name , market.id]
    end

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

  def find_raw_data_industry_monitoring
    @samples = {}
    (IndustryRawData.order("created_at DESC").limit(100) || []).each do |sample|
      @samples[sample.id] = {
        :cis_code => sample.cis_code,
        :country => sample.country.name,
        :manufacturer => sample.manufacturer.name,
        :salt_brand => sample.salt_brand.name,
        :other => sample.other,
        :iodine_level => sample.iodine_level,
        :category => sample.category,
        :month => sample.date.strftime('%Y/%m - %b'),
        :quarter => quater(sample.date),
        :date => sample.date.strftime('%d-%b-%Y')
      }
    end

    @borders = Border.order('name ASC').collect do |border|                 
      [border.name , border.id]                                               
    end                                                                         
                                                                                
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

  def import_monitoring
    @samples = {}
    (RawDataQualityMonitoring.order("created_at DESC").limit(100) || []).each do |sample|
      @samples[sample.id] = {
        :iir_code => sample.iir_code,
        :country => sample.country.name,
        :importer => sample.importer.name,
        :salt_brand => sample.salt_brand.name,
        :iodine_level => sample.iodine_level,
        :category => sample.category,
        :border => sample.point_of_entry.name,
        :volume => sample.volume_of_import,
        :month => sample.date.strftime('%Y/%m - %b'),
        :quarter => quater(sample.date),
        :date => sample.date.strftime('%d-%b-%Y')
      }
    end

    @borders = Border.order('name ASC').collect do |border|                 
      [border.name , border.id]                                               
    end                                                                         
                                                                                
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

=begin
  def create_market_raw_data
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
=end

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
    if quality_monitoring_raw_data(params)
      flash[:notice] = 'Successfully created.'                                
    else                                                                      
      flash[:error] = 'Something went wrong - did not create.'                
    end
    redirect_to "/raw_data_quality_monitoring" and return
  end

  def import_datagrid
    @markets = Transporter.order('name ASC').collect do |manu|           
      [manu.name , manu.id]                                                     
    end                                                                         
                                                                                
    @borders = Border.order('name ASC').collect do |border|                 
      [border.name , border.id]                                               
    end                                                                         
                                                                                
    @salt_types = SaltType.order('name ASC').collect do |salt|                  
      [salt.name , salt.id]                                                     
    end                                                                         
                                                                                
    @countries = Country.order('name ASC').collect do |country|      
      [country.name , country.id]                                       
    end

    @salt_brands = Product.order('name ASC').collect do |product|
      [product.name , product.id]
    end

  end

  def create_quality_monitoring_raw_data
    render :text => quality_monitoring_raw_data(params) and return
  end

  def update_quality_monitoring_raw_data
    render :text => update_monitoring_raw_data(params) and return
  end

  def industry_datagrid
    @manufacturers = Manufacturer.order('name ASC').collect do |manu|           
      [manu.name , manu.id]                                                     
    end                                                                         
                                                                                
    @borders = Border.order('name ASC').collect do |border|                 
      [border.name , border.id]                                               
    end                                                                         
                                                                                
    @salt_brands = Product.order('name ASC').collect do |product|                  
      [product.name , product.id]                                                     
    end
                                                                                
    @countries = Country.order('name ASC').collect do |country|      
      [country.name , country.id]                                       
    end
  end

  def raw_data_industry_create
    render :text => create_industry_raw_data(params) and return
  end

  def update_industry_datagrid
    render :text => update_industry_raw_data(params) and return
  end

  def market_datagrid
    @markets = Market.order('name ASC').collect do |manu|           
      [manu.name , manu.id]                                                     
    end                                                                         
                                                                                
    @salt_brands = Product.order('name ASC').collect do |product|                  
      [product.name , product.id]                                                     
    end                                                                         
                                                                                
    @manufacturers = Manufacturer.order('name ASC').collect do |manu|      
      [manu.name , manu.id]                                       
    end
                                                                                
    @counties = County.order('name ASC').collect do |district|      
      [district.name , district.id]                                       
    end

    @subcounties = SubCounty.order('name ASC').collect do |district|      
      [district.name , district.id]                                       
    end

  end

  def raw_data_market_create
    render :text => create_market_raw_data(params) and return
  end

  def raw_data_market_update
    render :text => update_market_raw_data(params) and return
  end

  private

  def quality_monitoring_raw_data(params)
    RawDataQualityMonitoring.transaction do
      sample = RawDataQualityMonitoring.new()
      sample.iir_code = params[:sample]['iir_code']
      sample.border_id = params[:sample]['border']
      sample.importer_id = params[:sample]['importer']
      sample.salt_brand_id = params[:sample]['salt_brand']
      sample.country_id = params[:sample]['country']
      sample.volume_of_import = params[:sample]['volume']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date'].to_date
      if sample.save
        return "sample id:#{sample.id}".to_json
      else
        return false
      end
    end
  end

  def update_monitoring_raw_data(params)
    RawDataQualityMonitoring.transaction do
      sample = RawDataQualityMonitoring.find(params[:sample]['sample_id'])
      sample.iir_code = params[:sample]['iir_code']
      sample.border_id = params[:sample]['border']
      sample.importer_id = params[:sample]['importer']
      sample.salt_brand_id = params[:sample]['salt_brand']
      sample.country_id = params[:sample]['country']
      sample.volume_of_import = params[:sample]['volume']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date'].to_date
      if sample.save
        return "sample id:#{sample.id}".to_json
      else
        return false
      end
    end
  end

  def create_industry_raw_data(params)
    IndustryRawData.transaction do
      country = Manufacturer.find(params[:sample]['company']).country
      sample = IndustryRawData.new()
      sample.cis_code = params[:sample]['cis_code']
      sample.salt_brand_id = params[:sample]['salt_brand']
      sample.other = params[:sample]['other']
      sample.brand_name_id = params[:sample]['company']
      sample.country_id = country.id
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date'].to_date
      if sample.save
        return "sample id:#{sample.id}".to_json
      else
        return false
      end
    end
  end

  def update_industry_raw_data(params)
    IndustryRawData.transaction do
      country = Manufacturer.find(params[:sample]['company']).country
      sample = IndustryRawData.find(params[:sample]['sample_id'])
      sample.cis_code = params[:sample]['cis_code']
      sample.salt_brand_id = params[:sample]['salt_brand']
      sample.other = params[:sample]['other']
      sample.brand_name_id = params[:sample]['company']
      sample.country_id = country.id
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date'].to_date
      if sample.save
        return "sample id:#{sample.id}".to_json
      else
        return false
      end
    end
  end

  def create_market_raw_data(params)
    RawDataMarket.transaction do
      sample = RawDataMarket.new()
      sample.manufacturer_id = params[:sample]['manufacturer']
      sample.county_id = params[:sample]['county']
      sample.sub_county_id = params[:sample]['sub_county']
      sample.market_id = params[:sample]['market']
      sample.salt_brand_id = params[:sample]['salt_brand']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date']
      if sample.save
        return "sample id:#{sample.id}".to_json
      else                                                                      
        return false
      end
    end
  end

  def update_market_raw_data(params)
    RawDataMarket.transaction do
      if params[:sample]['district'].blank?
        params[:sample]['district'] = Market.find(params[:sample]['market']).district_id
      end
      sample = RawDataMarket.find(params[:sample]['sample_id'])
      sample.manufacturer_id = params[:sample]['manufacturer']
      sample.county_id = params[:sample]['county']
      sample.sub_county_id = params[:sample]['sub_county']
      sample.market_id = params[:sample]['market']
      sample.salt_type_id = params[:sample]['salt_type']
      sample.iodine_level = params[:sample]['iodine_level']
      sample.category = params[:sample]['category']
      sample.date = params[:sample]['date']
      if sample.save
        return "sample id:#{sample.id}".to_json
      else                                                                      
        return false
      end
    end
  end

  def get_category(level)
    if(level < 25)
      return "Below Market Min"
    elsif(level >= 25 && level <= 49.9 )
      return "Factory Min-Market Min"
    elsif(level < 50)                                          
      return "< Factory Min"                     
    elsif(level >= 50 && level <= 84)                              
      return "Production Range"
    elsif(level > 84)                           
      return "> Factory Max"                           
    end
  end

end
