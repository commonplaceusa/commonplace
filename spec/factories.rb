
Factory.define :community do |c|
  c.name { Forgery(:address).city }
  c.code { Forgery(:basic).password }
end

Factory.define :user do |u|
  u.first_name { Forgery(:name).first_name }
  u.last_name { Forgery(:name).last_name }
  u.skill_list { Array.new((0..4).random){Forgery(:personal).language}.join(',')}
  u.interest_list { Array.new((0..4).random){Forgery(:basic).color}.join(',')}
  u.email {|u| "#{u.first_name}.#{u.last_name}@example.com".downcase }
  u.password { Forgery(:basic).password }
  u.password_confirmation {|u| u.password }
  u.address { "#{Forgery(:address).street_address}, #{Forgery(:address).city}, #{Forgery(:address).state}" }
  u.about { Forgery(:lorem_ipsum).paragraphs(1) }
end


Factory.define :post do |p|
  p.body { Forgery(:lorem_ipsum).paragraphs(1) }
  p.association :community
  p.association :user
  p.after_build do |p| 
    p.type = "Request"
  end
end

Factory.define :reply do |r|
  r.body { Forgery(:lorem_ipsum).paragraph }
  r.association :user
  r.association :post
end
