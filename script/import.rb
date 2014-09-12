require 'csv'
  
def start
  country = add_countries

  counties = CSV.read("/home/mwatha/Documents/Makhumula/county.csv")
  count = counties.length
  failed = []

  (counties || []).each_with_index do |county, i|
    puts ".................. #{county[0].strip}"
    name = county[0] 
    population = county[1]
    description = county[2]
    des = population + ": " + description unless population.blank?
    if des.blank? and not population.blank?
      des = population 
    end
    if name.blank?
      failed << county
      next
    end

    District.transaction do
      district = District.new()
      district.name = name.strip.titleize
      district.country_id = country.id
      district.description = description.strip.titleize unless description.blank? 
      district.save
      puts "Added county: #{county[0].strip.titleize}  .... #{i} of #{count}"
    end
  end
  puts ""
  puts "Failed: #{failed.to_yaml}"


  add_brands
end

def add_brands
  country = Country.first

  brands = CSV.read("/home/mwatha/Documents/Makhumula/brand.csv")
  names = []
  (brands || []).each_with_index do |brand, i|
    name = brand[0]
    next if name.blank?
    names << name.strip.titleize
  end

  count = names.uniq.length

  (names.uniq || []).each_with_index do |name, i|
    next if name.blank?
    Manufacturer.transaction do
      man = Manufacturer.new()
      man.name = name.strip.titleize
      man.country_id = country.id
      man.save
      puts "Added brand: #{name.strip.titleize}  .... #{i} of #{count}"
    end
  end

end

def add_countries
 country = Country.new()
 country.name = 'Kenya' 
 country.description = 'East and central Africa'
 country.save
 return country
end

start
