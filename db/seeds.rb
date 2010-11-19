# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


community = Community.create(:name => "Test", :slug => "test")
Neighborhood.create(:name => "n1", 
                    :about => "test neighborhood 1", 
                    :community => community)
