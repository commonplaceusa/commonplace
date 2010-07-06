
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
end


Factory.define :post do |f|
  f.body { Forgery(:lorem_ipsum).paragraphs(1) }
  f.association :user
end

Factory.define :reply do |f|
  f.body { Forgery(:lorem_ipsum).paragraph }
  f.association :user
  f.association :post
end

Factory.define :event do |f|
  f.name { Forgery(:lorem_ipsum).words(2) }
end

Factory.define :organization do |f|
  f.name { Forgery(:name).company_name }
  f.website ""
end
  
Factory.define :business do |f|
  f.name { Forgery(:name).company_name }
  f.website ""
  f.about { Forgery(:lorem_ipsum).paragraph }
  f.address { "#{Forgery(:address).street_address}, #{Forgery(:address).city}, #{Forgery(:address).state}" }
end

Factory.define :business_sponsorship, :class => :sponsorship do |f|
  f.association :sponsor, :factory => :business
  f.association :event
end

Factory.define :organization_sponsorship, :class => :sponsorship do |f|
  f.association :sponsor, :factory => :organization
  f.association :event
end

Factory.define :attendance do |f|
  f.association :user
  f.association :event
end

Factory.define :text_module do |f|
  f.title { Forgery(:lorem_ipsum).words 2 }
  f.body { Forgery(:lorem_ipsum).paragraph }
  f.association :organization
  f.position 1
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
  f.association :user
  f.association :conversation
end

Factory.define :referral do |f|
  f.association :event
  f.association :referee, :factory => :user
  f.association :referrer, :factory => :user
end
