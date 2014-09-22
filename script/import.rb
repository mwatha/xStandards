require 'csv'

def start
  csv_text = CSV.read("/home/mwatha/Documents/Makhumula/county.csv")
  country = create_countries

  counties = {}

  (csv_text).each do |county|
    name = county[0].titleize.squish rescue nil
    population = county[1].squish rescue nil
    sub_counties = county[2].gsub('Constituencies:','').squish.split(',') rescue []
    next if name.blank?

    if counties[name].blank?
      counties[name] = {:population => population,:sub_counties => []}
    end

    (sub_counties || []).each do |sub|
      counties[name][:sub_counties] << sub.squish.titleize
    end
    counties[name][:sub_counties] = counties[name][:sub_counties].uniq rescue []

  end

  (counties || {}).each_with_index do |(county, data), i|
    c = create_county(country, county, data[:population])
    create_subcounties(c, data[:sub_counties])
    puts "created county: #{county}........... #{i+1} OF #{counties.length}"
  end

  create_manufacturers(country)

end

def create_manufacturers(country)
  csv_text = CSV.read("/home/mwatha/Documents/Makhumula/brand.csv")
  brands = []
  (csv_text || []).each do |brand|
    b = brand[0].squish.titleize rescue nil
    next if b.blank?
    brands << b
  end

  brands = brands.uniq

  (brands || []).each_with_index do |name, i|
    brand = Manufacturer.new
    brand.name = name
    brand.country_id = country.id
    brand.save
    puts "Created manufacturer: #{name} .... #{i+1} of #{brands.length}"
  end

  create_brand(brands)
  create_markets
end

def create_markets
  market = Market.new
  market.name = 'Unknown'
  market.district_id = County.where(:'name' => 'Nairobi')[0].sub_counties[0].id
  market.save
  puts "Created market: #{market.name} .... "
end

def create_brand(brand_names)
  (brand_names || []).each_with_index do |name, i|
    brand = Product.new
    brand.name = name
    brand.manufacturer_id = Manufacturer.where(:'name' => name)[0].id
    brand.save
    puts "Created brand/product: #{name} .... #{i+1} of #{brand_names.length}"
  end
end

def create_county(country, county_name, population = nil)
  c = County.new
  c.name = county_name
  c.country_id = country.id
  c.description = population unless population.blank?
  c.save
  return c
end

def create_subcounties(county, sub_counties)
  (sub_counties || []).each do |name|
    c = SubCounty.new
    c.name = name
    c.county_id = county.id
    c.save
    puts "Sub county: #{name}"
  end
end


def create_countries
  #return Country.find(1)
  c = Country.new
  c.name = 'Kenya'
  c.save
  return c
end


start
