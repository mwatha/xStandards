class SubCounty < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :county ,:class_name => :County, :foreign_key => :county_id                                                   
  has_many :markets, :class_name => :Market ,:foreign_key => :district_id
end
