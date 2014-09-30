require 'csv'

def start

  csv_text = CSV.read("/home/mwatha/Documents/Makhumula/Market_results.csv")
  (csv_text || []).each_with_index do |result, i|
    code = result[0].squish.titleize rescue nil
    date = result[1].squish.sub("-","/").sub("-","/20").to_date rescue nil
    county = result[2].squish.titleize rescue nil
    producer = result[3].squish.titleize rescue nil
    value = result[4].squish.to_f rescue nil

    next if date.blank?
    next if value.blank?
    next if county.blank?
    next if producer.blank?

    valid_producer_product = validate_producer_brand(producer)
    valid_county_subcounty = valid_county_sub_county(county)
    next if valid_producer_product.blank?
    next if valid_county_subcounty.blank?

    r = RawDataMarket.new
    r.manufacturer_id = valid_producer_product[0].id
    r.salt_brand_id = valid_producer_product[1].id
    r.county_id = valid_county_subcounty[0].id
    r.sub_county_id =  valid_county_subcounty[1].id
    r.category = get_category(value)
    r.iodine_level = value
    r.date = date
    r.market_id =  valid_county_subcounty[1].markets[0].id
    r.save
    puts "Entered result: #{code} .... #{i+1} OF #{csv_text.length - 1}"
  end

end

def valid_county_sub_county(county)
  valid_county = County.where(:'name' => county)[0] rescue nil
  if valid_county
    sub_counties = valid_county.sub_counties
    if sub_counties.length == 1
      return [valid_county, sub_counties.first]
    elsif sub_counties.length > 1
      return [valid_county, sub_counties.first]
    end
  end
  return []
end

def validate_producer_brand(producer = [])
  valid_producer = Manufacturer.where(:'name' => producer)[0] rescue nil
  if valid_producer
    products = valid_producer.products
    if products.length == 1
      return [valid_producer,products.first]
    elsif products.length > 1
      return [valid_producer,products.first]
    end
  end
  return []
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
