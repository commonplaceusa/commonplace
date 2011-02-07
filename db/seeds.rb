# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


community = Community.create!(:name => "Test", :slug => "test", :zip_code => "02132")
neighborhood = Neighborhood.create!(:name => "n1", 
                                    :community => community,
                                    :bounds => [[42.29337, -71.16252], [42.29061, -71.16827], [42.28391, -71.16162], [42.28163, -71.16004], [42.28077, -71.15819], [42.2848, -71.15669], [42.28614, -71.1548], [42.29061, -71.15999]])
user = User.create!(:first_name => "test", :last_name => "dev",
                    :email => "test@example.com", :address => "420 Baker St.",
                    :password => "password", :neighborhood => neighborhood,
                     :community => community)
user.admin = true
user.save!
post = Post.create(:body => "This is a test post",
                    :user => user,
                    :subject => "Subject",
                    :area => neighborhood)
post.save

event = Event.create(:name => "Test Event", :description => "Event for testing", :owner => User.find(:first), :date => Time.now)
event.save
