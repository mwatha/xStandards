class Manufacturer < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :products, :class_name => :Product,:foreign_key => :manufacturer_id
end
