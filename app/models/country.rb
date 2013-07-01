class Country < ActiveRecord::Base
  #default_scope where("#{table_name}.voided = 0")
  # attr_accessible :title, :body
  has_many :borders, :class_name => :Border ,:foreign_key => :country_id     
  has_many :districts, :class_name => :District ,:foreign_key => :country_id
    
end
