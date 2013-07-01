


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




start
