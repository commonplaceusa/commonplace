# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


community = Community.create(:name => "Test", :slug => "test", :zip_code => "02132")
neighborhood = Neighborhood.create(:name => "n1", 
                                  :about => "test neighborhood 1", 
                                  :community => community)
user = User.create(:first_name => "test", :last_name => "dev",
                   :email => "test@example.com", :location => Location.new(:zip_code => "02132", :street_address => "420 Baker St."),
                   :password => "password", :neighborhood => neighborhood,
                   :avatar => Avatar.new)

