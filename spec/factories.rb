Factory.define :community do |f|
  f.name { Forgery(:address).city }
end

Factory.define :neighborhood do |f|
  f.name { Forgery(:address).street_name }
  f.north_bound { rand(180) - 90 }
  f.south_bound {|n| n.north_bound - rand(5)}
  f.east_bound { rand(360) - 180 }
  f.west_bound {|n| n.east_bound - rand(5)}
  f.about Forgery(:lorem_ipsum).paragraphs(1)
  f.association :community 
end

Factory.define :avatar do |f|
end

Factory.define :user do |f|
  f.first_name { Forgery(:name).first_name }
  f.last_name { Forgery(:name).last_name }
  f.skill_list { Array.new((0..4).random){Forgery(:personal).language}.join(',')}
  f.interest_list { Array.new((0..4).random){Forgery(:basic).color}.join(',')}
  f.email {|u| "#{u.first_name}.#{u.last_name}@example.com".downcase }
  f.password { Forgery(:basic).password }
  f.association :location
  f.about { Forgery(:lorem_ipsum).paragraphs(1) }
  f.association :avatar
  f.association :neighborhood
end

Factory.define :location do |f|
  f.street_address "420 Baker St."
  f.zip_code "02132"
end

Factory.define :post do |f|
  f.body { Forgery(:lorem_ipsum).paragraphs(1) }
  f.association :user
end

Factory.define :event do |f|
  f.name { Forgery(:lorem_ipsum).words(2) }
  f.description { Forgery(:lorem_ipsum).paragraph }
  f.date { Time.now + rand(6).week }
  f.start_time { Time.parse("#{rand(24)}:#{rand(60)}") }
  f.association :owner
end

Factory.define :announcement do |f|
  f.subject { Forgery(:lorem_ipsum).words(2) }
  f.body { Forgery(:lorem_ipsum).paragraph }
  f.association :feed
end

Factory.define :feed do |f|
  f.name { Forgery(:name).company_name }
  f.association :avatar
  f.after_build {|o| o.profile_fields = [] }
end
  
Factory.define :message do |f|
  f.association :user
  f.association :recipient, :factory => :user
  f.subject { Forgery(:lorem_ipsum).words(2) }
  f.body { Forgery(:lorem_ipsum).sentence }
end

Factory.define :referral do |f|
  f.association :event
  f.association :referee, :factory => :user
  f.association :referrer, :factory => :user
end
