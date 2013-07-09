
def kenya                                                                       
  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/kenya.csv")         
  country =  Country.new()
  country.name = "Kenya"
  country.save

  districts = []
  manufacturers = []
  markets = []
  market_hash = {}
   
  (csv_text || []).each do |line|                                               
    next if line[0] == 'LAB NO'                                                 
    districts << line[1].titleize
    districts = districts.uniq
    manufacturers << line[2].titleize
    manufacturers = manufacturers.uniq
    markets << [get_random_market,line[1].titleize]
    market_hash[line[1].titleize] = get_random_market
    markets = markets.uniq
  end               
  
  (manufacturers || []).each do |name|
    create_manufacturer(name)
  end
  
  (districts || []).each do |name|
    create_district(name)
  end
  
  (market_hash || {}).each do |district_name , name |
    create_market(name , district_name)
  end
  
  

  (csv_text || []).each do |line|                                               
    next if line[0] == 'LAB NO'                                                 
    params = {}
    params['sample'] = {
      :manufacturer => Manufacturer.where("name = ?",line[2].titleize).first.id,
      :district => District.where("name = ?",line[1].titleize).first.id,
      :salt_type => get_type_of_salt,
      :market => Market.where("name = ?", market_hash[line[1].titleize]).first.id,
      :category => get_category(line[3].to_f),
      :iodine_level => line[3],
      :date => get_random_date
    }
    create_market_raw_data(params)                                            
  end 
                                                              
end

def get_type_of_salt
  [*1..3].sample
end

def get_random_date
  Time.at(Time.now.to_i - rand(100000000)).to_date
end

def get_random_market
  Faker::Name.last_name
end

def create_market_raw_data(params)                                            
  RawDataMarket.transaction do                                                
    sample = RawDataMarket.new()                                              
    sample.manufacturer_id = params['sample'][:manufacturer]                  
    sample.district_id = params['sample'][:district]                          
    sample.market_id = params['sample'][:market]                              
    sample.salt_type_id = params['sample'][:salt_type]                        
    sample.iodine_level = params['sample'][:iodine_level]                     
    sample.category = params['sample'][:category]                             
    sample.date = params['sample'][:date]                                     
    if sample.save                                                            
      puts "sample id:#{sample.id}"
    else                                                                      
      puts "false"                                                            
    end                                                                       
  end                                                                         
end

def create_manufacturer(name)
  Manufacturer.transaction do 
    r = Manufacturer.new
    r.name = name.titleize
    r.country_id = get_country('Kenya').id
    r.save
    puts "Manufacturer: #{name.titleize}"
  end
end

def create_district(name)
  District.transaction do 
    r = District.new
    r.name = name.titleize
    r.country_id = get_country('Kenya').id
    r.save
    puts "District: #{name.titleize}"
  end
end

def create_market(name,district)
  Market.transaction do 
    r = Market.new
    r.name = name.titleize
    r.district_id = District.where("name = ?",district.titleize).first.id
    r.save
    puts "Market: #{name.titleize}"
  end
end










def start
  countries = []
  borders = {}
=begin
  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/raw_data.csv")
  (csv_text || []).each do |line|
    record = line[6]
    next if record.blank?

    countries << line[6].titleize
    countries = countries.uniq

    if borders[line[6].titleize].blank?
      borders[line[6].titleize] = []
    end
    borders[line[6].titleize] << line[3]
    borders[line[6].titleize] = borders[line[6].titleize].uniq

  end

  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/countries.csv")
  (csv_text || []).each do |name|
    next if name[0].blank?
    Country.transaction do 
      country = Country.new
      country.name = name[0].titleize
      country.save
      puts "Country: #{name[0].titleize}"
    end
  end

  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/districts.csv")
  (csv_text || []).each do |name|
    next if name[0].blank?
    District.transaction do 
      r = District.new
      r.name = name[0].titleize
      r.country_id = get_country('Malawi').id
      r.save
      puts "District: #{name[0].titleize}"
    end
  end

  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/importer.csv")
  (csv_text || []).each do |name|
    next if name[0].blank?
    Transporter.transaction do 
      r = Transporter.new
      r.name = name[0].titleize
      r.transporter_type = 1
      r.save
      puts "Importer: #{name[0].titleize}"
    end
  end

  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/border_key.csv")
  (csv_text || []).each do |name|
    next if name[0].blank?
    next if name[1].blank?
    Border.transaction do 
      r = Border.new
      r.name = name[0].titleize
      r.country_id = get_country('Malawi').id
      r.description = name[1].upcase
      r.save
      puts "Border: #{name[0].titleize}"
    end
  end

  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/manufacturers.csv")
  (csv_text || []).each do |name|
    next if name[0].blank?
    Manufacturer.transaction do 
      r = Manufacturer.new
      r.name = name[0].titleize
      r.country_id = get_country('Malawi').id
      r.save
      puts "Manufacturer: #{name[0].titleize}"
    end
  end
=end
  csv_text = FasterCSV.read("/home/mwatha/Desktop/migration/raw_data.csv")
  (csv_text || []).each do |line|
    next if line[2].blank?
    next if line[2].upcase == 'X'
    next if line[2].upcase == 'IIR/10/250'
    puts "importing sample: #{line[2]}"
    RawDataQualityMonitoring.transaction do 
      r = RawDataQualityMonitoring.new
      r.iir_code = line[2].upcase
      r.border_id = get_border(line[3].upcase).id
      r.importer_id = get_importer(line[4].titleize).id
      r.salt_type_id = get_salt_type(line[5].titleize).id
      r.country_id = get_country(line[6]).id
      r.volume_of_import = line[7].to_f rescue 0.0
      r.iodine_level = line[8].to_f
      r.category = get_category(line[8].to_f)
      r.date = get_date(line[1])
      r.save
    end
  end

end

def get_date(d)
  "#{d[0..5]}20#{d[-2..-1]}".to_date
end

def get_category(level)
  if(level < 45)
    return "Below Market Min"                          
  elsif(level >= 45 && level <= 49.9 )
    return "Factory Min-Market Min";                    
  elsif(level < 50)
    return "< Factory Min"                           
  elsif(level >= 50 && level <= 84)
    return "Production Range"                          
  elsif(level > 84)
    return "> Factory Max"
  end

end

def get_salt_type(name)
  t = SaltType.where("name = ?",name).last rescue nil
  if t.blank?
    t = SaltType.where("name = 'Other'").last
  end
  return t
end

def get_importer(name)
  Transporter.where("name = ?",name).last
end

def get_border(code)
  Border.where("description = ?",code).last
end

def get_country(name)
  Country.where("name = ?", name.strip.titleize).last rescue Country.where("name = 'Malawi'").last
end



kenya
#start
