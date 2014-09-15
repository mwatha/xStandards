class IndustryRawData < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :country ,:class_name => :Country, :foreign_key => :country_id                                                        
  belongs_to :manufacturer ,:class_name => :Manufacturer, :foreign_key => :brand_name_id                                                        
  belongs_to :salt_brand ,:class_name => :Product, :foreign_key => :salt_brand_id                                                       
end
