class Sample < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :product ,:class_name => :Product, :foreign_key => :product_id                                                        
end
