class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :manufacturer , :class_name => :Manufacturer, :foreign_key => :manufacturer_id                                                            
end
