class RawDataMarket < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :manufacturer ,:class_name => :Manufacturer, :foreign_key => :manufacturer_id                                                        
  belongs_to :district ,:class_name => :District, :foreign_key => :district_id                                                        
  belongs_to :market ,:class_name => :Market, :foreign_key => :market_id                                                        
  belongs_to :salt_type ,:class_name => :SaltType, :foreign_key => :salt_type_id                                                       
end
