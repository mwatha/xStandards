class RawDataMarket < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :manufacturer ,:class_name => :Manufacturer, :foreign_key => :manufacturer_id                                                        
  belongs_to :county ,:class_name => :County, :foreign_key => :county_id                                                        
  belongs_to :sub_county ,:class_name => :SubCounty, :foreign_key => :sub_county_id                                                        
  belongs_to :market ,:class_name => :Market, :foreign_key => :market_id                                                        
  belongs_to :salt_brand ,:class_name => :Product, :foreign_key => :salt_brand_id                                                       
end
