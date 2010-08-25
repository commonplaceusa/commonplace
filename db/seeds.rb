# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'factory_girl'
require 'forgery'



communities = [Factory(:community), Factory(:community)]

user = Factory(:user, :community => communities[0],
               :email => "test@example.com",
               :password => "toast")

users = [Factory(:user, :community => communities[0]),
         Factory(:user, :community => communities[0]),
         Factory(:user, :community => communities[0]),
         Factory(:user, :community => communities[0])]
         

posts = [Factory(:post, :user => users[0]),
         Factory(:post, :user => users[0]),
         Factory(:post, :user => users[1]),
         Factory(:post, :user => users[2]),
         Factory(:post, :user => users[3])]

organizations = [Factory(:organization, :community => communities[0]),
                 Factory(:organization, :community => communities[0]),
                 Factory(:organization, :community => communities[0]),
                 Factory(:organization, :community => communities[0])]

events = [Factory(:event, :organization => organizations[0]),
          Factory(:event, :organization => organizations[0]),
          Factory(:event, :organization => organizations[1]),
          Factory(:event, :organization => organizations[1]),
          Factory(:event, :organization => organizations[2]),
          Factory(:event, :organization => organizations[2]),
          Factory(:event, :organization => organizations[3]),
         ]

announcements = [Factory(:announcement, :organization => organizations[0]),
                 Factory(:announcement, :organization => organizations[0]),
                 Factory(:announcement, :organization => organizations[0]),
                 Factory(:announcement, :organization => organizations[2]),
                 Factory(:announcement, :organization => organizations[2]),
                 Factory(:announcement, :organization => organizations[3])]

