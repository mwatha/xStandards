require 'csv'

def start
  country = Country.find(1)

  brand_name  = Manufacturer.find(1)

  csv_text = CSV.read("/home/mwatha/Documents/Makhumula/industry_results.csv")
  (csv_text || []).each_with_index do |result, i|
    cis_code = result[0].squish.titleize rescue nil
    date = result[3].squish.to_date rescue nil
    matrix = result[4].squish.titleize rescue nil
    test = result[5].squish.titleize rescue nil
    param = result[6].squish.titleize rescue nil
    value = result[7].squish.to_f rescue nil
    units = result[8].squish rescue nil
    producer = result[1].squish.titleize rescue nil
    brand = result[2].squish.titleize rescue nil

    other = param + " " + matrix + " " + test rescue nil
    next if date.blank?
    next if cis_code.blank?
    next if value.blank?

    valid_producer_product = validate_producer_brand(producer, brand)
    next if valid_producer_product.blank?

    r = IndustryRawData.new
    r.cis_code = cis_code
    r.country_id = country.id
    r.brand_name_id = valid_producer_product[0].id
    r.salt_brand_id = valid_producer_product[1].id
    r.other = other
    r.category = get_category(value)
    r.iodine_level = value
    r.date = date
    r.save
    puts "Entered result: #{cis_code} .... #{i+1} OF #{csv_text.length - 1}"
  end

end

def validate_producer_brand(producer = [], brand_name = [])
  valid_brand = Product.where(:'name' => brand_name)[0] rescue nil
  valid_producer = Manufacturer.where(:'name' => producer)[0] rescue nil
  if not valid_brand.blank? and not valid_producer.blank?
    return [valid_producer, valid_brand]
  elsif not valid_brand.blank? and valid_producer.blank?
    valid_producer = valid_brand.manufacturer
    return [valid_producer, valid_brand]
  elsif valid_brand.blank? and not valid_producer.blank?
    valid_brand = create_product(valid_producer,brand_name)
    return [valid_producer, valid_brand]
  end
  return []
end

def create_product(producer, brand_name)
  brand = Product.new
  brand.name = brand_name
  brand.manufacturer_id = producer.id
  brand.save
  return brand
end

def get_category(level)
  if(level < 25)                                                
    return "Below Market Min"                     
  elsif(level >= 25 && level <= 49.9)                           
    return "Factory Min-Market Min"
  elsif(level < 50)                                                         
    return "< Factory Min"
  elsif(level >= 50 && level <= 84)
    return "Production Range"
  elsif(level > 84)                                                   
    return "> Factory Max"
  end
end


start
