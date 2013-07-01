class Border < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :country ,:class_name => :Country, :foreign_key => :country_id                                                   
end
