class Manufacturer < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :products, :class_name => :Product,:foreign_key => :manufacturer_id
  belongs_to :country ,:class_name => :Country, :foreign_key => :country_id                                                        
end
