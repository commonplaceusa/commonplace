# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'factory_girl'
require 'forgery'

puts %[-- creating community]
communities = [Factory(:community, :name => "West Roxbury", :slug => "westroxbury")]

puts %[-- creating neighborhoods]
neighborhoods = Array.new(5) { Factory(:neighborhood, :community => communities[0])}

puts %[-- creating user (:email => "test@example.com", :password => "toast")]
user = Factory(:user, :neighborhood => neighborhoods[0],
               :email => "test@example.com",
               :password => "toast")

puts %[-- creating users]
users = Array.new(5) {|i|Array.new(4) {Factory(:user, :neighborhood => neighborhoods[i])}}.flatten

puts %[-- creating posts]
posts = [Factory(:post, :user => users[0]),
         Factory(:post, :user => users[0]),
         Factory(:post, :user => users[1]),
         Factory(:post, :user => users[2]),
         Factory(:post, :user => users[3])]

puts %[-- creating organizations]
organizations = Array.new(4){Factory(:organization, :community => communities[0])}

puts %[-- creating events]
events = [Factory(:event, :organization => organizations[0]),
          Factory(:event, :organization => organizations[0]),
          Factory(:event, :organization => organizations[1]),
          Factory(:event, :organization => organizations[1]),
          Factory(:event, :organization => organizations[2]),
          Factory(:event, :organization => organizations[2]),
          Factory(:event, :organization => organizations[3]),
         ]

puts %[-- creating announcements]
announcements = [Factory(:announcement, :organization => organizations[0]),
                 Factory(:announcement, :organization => organizations[0]),
                 Factory(:announcement, :organization => organizations[0]),
                 Factory(:announcement, :organization => organizations[2]),
                 Factory(:announcement, :organization => organizations[2]),
                 Factory(:announcement, :organization => organizations[3])]

