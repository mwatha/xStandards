class RawDataQualityMonitoring < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :country ,:class_name => :Country, :foreign_key => :country_id                                                        
  belongs_to :importer ,:class_name => :Transporter, :foreign_key => :importer_id                                                       
  belongs_to :point_of_entry ,:class_name => :Border, :foreign_key => :border_id                                                        
  belongs_to :salt_brand ,:class_name => :Product, :foreign_key => :salt_brand_id                                                       
end
