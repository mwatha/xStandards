# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


t_types = ['Transporter' , 'Packer']              
                             
t_types.each do |name|
  tp = TransporterType.new()
  tp.name = name
  tp.save
end                             

salt_types = ['Fine' , 'Coarse','Other']              
                             
salt_types.each do |name|
  salt = SaltType.new()
  salt.name = name
  salt.save
end                             
=begin
countries = ['Kenya' , 'Malawi']              
                             
countries.each do |name|
  country = Country.new()
  country.name = name
  country.save
end                             
=end

user_roles = ['admin','superuser','standard']
user_roles.each do |role|
  r = UserRoleType.new()
  r.name = role
  r.save
end

person = Person.new()
person.first_name = 'Super'
person.last_name = 'User'   
person.save
                           
user = User.new()
user.username = 'admin'
user.password_hash = 'admin'
user.person_id = person.id   
user.save

role = UserRole.new()
role.user_id = user.id
role.role = 'admin'
role.save
                           
puts "Your new user is: admin, password: admin"
