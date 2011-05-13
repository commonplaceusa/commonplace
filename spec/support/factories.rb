Factory.define :community do |f|
  f.name { Forgery(:address).city }
  f.time_zone { "Eastern Time (US & Canada)" }
  f.zip_code { "02132" }
end

Factory.define :neighborhood do |f|
  f.name { Forgery(:address).street_name }
  f.association :community 
end


Factory.define :user do |f|
  f.first_name { Forgery(:name).first_name }
  f.last_name { Forgery(:name).last_name }
  f.email {|u| "#{u.first_name}.#{u.last_name}@example.com".downcase }
  f.password { Forgery(:basic).password }
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
  f.about { Forgery(:basic).text }
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
