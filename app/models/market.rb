class Market < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :district ,:class_name => :District, :foreign_key => :district_id                                                   
end
