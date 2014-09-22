class County < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :country ,:class_name => :Country, :foreign_key => :country_id                                                   
  has_many :sub_counties, :class_name => :SubCounty ,:foreign_key => :county_id
end
