class Transporter < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :category ,:class_name => :TransporterType, :foreign_key => :transporter_type                                                   
end
