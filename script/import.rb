require 'csv'

def start
  csv_text = CSV.read("/home/mwatha/Documents/Makhumula/county.csv")
  #country = create_countries

  counties = {}

  (csv_text).each do |county|
    name = county[0].titleize.squish rescue nil
    population = county[1].squish rescue nil
    sub_counties = county[2].gsub('Constituencies:','').squish.split(',') rescue []
    next if name.blank?

    if counties[name].blank?
      counties[name] = {:description => population,:sub_counties => []}
    end

    (sub_counties || []).each do |sub|
      counties[name][:sub_counties] << sub.squish.titleize
    end
    counties[name][:sub_counties] = counties[name][:sub_counties].uniq rescue []

  end

  counties.each do |c,s|
    puts "........... #{s.to_yaml}"
  end


end

def create_countries
  c = Country.new
  c.name = 'Kenya'
  c.save
  return c
end


start
