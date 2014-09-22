require 'csv'

def start
  country = Country.find(1)

  brand_name  = Manufacturer.find(1)

  csv_text = CSV.read("/home/mwatha/Documents/Makhumula/Salt_results.csv")
  (csv_text || []).each_with_index do |result, i|
    cis_code = result[0].squish.titleize rescue nil
    date = result[1].squish.to_date rescue nil
    matrix = result[2].squish.titleize rescue nil
    test = result[3].squish.titleize rescue nil
    param = result[4].squish.titleize rescue nil
    value = result[5].squish.to_f rescue nil
    units = result[6].squish rescue nil

    other = param + " " + matrix + " " + test rescue nil
    next if date.blank?
    next if cis_code.blank?
    next if value.blank?

    r = IndustryRawData.new
    r.cis_code = cis_code
    r.country_id = country.id
    r.brand_name_id = brand_name.id
    r.salt_brand_id =brand_name.products[0].id
    r.other = other
    r.category = get_category(value)
    r.iodine_level = value
    r.date = date
    r.save
    puts "Entered result: #{cis_code} .... #{i+1} OF #{csv_text.length - 1}"
  end

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
