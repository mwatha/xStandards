class Market < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :county ,:class_name => :County, :foreign_key => :district_id                                                   
end
