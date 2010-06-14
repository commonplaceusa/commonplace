 
 Factory.define :user do |f|
   f.password { Forgery(:basic).password }
   f.password_confirmation {|a| a.password }
   f.first_name { Forgery(:name).first_name }
   f.last_name  { Forgery(:name).last_name }
   f.address { Forgery(:address).street_address }
   f.email { Forgery(:internet).email_address }
   f.about { Forgery(:lorem_ipsum).paragraph }
 end

 Factory.define :post do |f|
   f.body { Forgery(:lorem_ipsum).paragraph }
   f.association :user, :factory => :user
 end

 Factory.define :reply do |f|
   f.body { Forgery(:lorem_ipsum).sentence }
   f.association :user, :factory => :user
   f.association :post, :factory => :post
 end

 Factory.define :organization do |f|
   f.name { Forgery(:name).company_name }
 end
   
 Factory.define :event do |f|
   f.name { Forgery(:lorem_ipsum).words(2) }
 end

 
