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
  f.password_confirmation {|u| u.password }
  f.address { "#{Forgery(:address).street_address}, #{Forgery(:address).city}, #{Forgery(:address).state}" }
  f.about { Forgery(:lorem_ipsum).paragraphs(1) }
  f.association :avatar
  f.association :neighborhood
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
  f.association :organization
  f.address { "#{Forgery(:address).street_address}, #{Forgery(:address).city}, #{Forgery(:address).state}" }
end

Factory.define :announcement do |f|
  f.subject { Forgery(:lorem_ipsum).words(2) }
  f.body { Forgery(:lorem_ipsum).paragraph }
  f.association :organization
end

Factory.define :organization do |f|
  f.name { Forgery(:name).company_name }
  f.website { "http://" + Forgery(:internet).domain_name }
  f.address { "#{Forgery(:address).street_address}, #{Forgery(:address).city}, #{Forgery(:address).state}" }
  f.association :avatar
  f.after_build {|o| o.profile_fields = [] }
end
  
Factory.define :message do |f|
  f.association :user
  f.association :conversation
  f.body { Forgery(:lorem_ipsum).sentence }
end

Factory.define :conversation do |f|
  f.subject { Forgery(:lorem_ipsum).words(2) }
end

Factory.define :conversation_membership do |f|
  f.association :conversation
  f.association :user
end


Factory.define :referral do |f|
  f.association :event
  f.association :referee, :factory => :user
  f.association :referrer, :factory => :user
end
