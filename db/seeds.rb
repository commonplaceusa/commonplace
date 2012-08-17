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

address = StreetAddress.create!(:address => "221B Baker St.",
                                :unreliable_name => "test dev",
                                :community => community)

StreetAddress.create!(:address => "22 Mott St.",
                      :unreliable_name => "John Smith",
                      :community => community)

resident = Resident.create!(:first_name => "test",
                            :last_name => "dev",
                            :email => "test@example.com",
                            :community => community,
                            :manually_added => true)

Resident.create!(:first_name => "John",
                 :last_name => "Smith",
                 :email => "johnsmith@example.com",
                 :community => community)

Resident.create!(:first_name => "Will",
                 :last_name => "Smith",
                 :address => "22 Mott St.",
                 :community => community)

user = User.create!(:first_name => "test", :last_name => "dev",
                    :email => "test@example.com", :address => "221B Baker St.",
                    :password => "password", :neighborhood => neighborhood,
                     :community => community, :referral_source => "Other")

community.add_default_groups!
user.admin = true
user.save!

post = Post.create(:body => "This is a test post",
                    :user => user,
                    :subject => "Subject",
                    :community => community)
post.save

event = Event.create(:name => "Test Event", :description => "Event for testing", :owner => User.find(:first), :date => Time.now, :start_time => Time.now, :end_time => (Time.now + 60*60*24*3))
event.save

