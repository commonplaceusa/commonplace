FactoryGirl.define do
  factory :community do |f|
    f.name { Forgery(:address).city }
    f.time_zone { "Eastern Time (US & Canada)" }
    f.zip_code { "02132" }
    f.slug { Forgery(:address).city }
    f.network_type { "type" }
  end

  factory :neighborhood do |f|
    f.name { Forgery(:address).street_name }
    f.association :community 
  end


  factory :user do |f|
    f.first_name { Forgery(:name).first_name }
    f.last_name { Forgery(:name).last_name }
    f.email {|u| "#{u.first_name}.#{u.last_name}@example.com".downcase }
    f.address { "1 Any Ln" }
    f.password { Forgery(:basic).password }
    f.referral_source { "Somewhere" }
  end

  factory :post do |f|
    f.body { Forgery(:lorem_ipsum).paragraphs(1) }
    f.association :user
  end

  factory :event do |f|
    f.name { Forgery(:lorem_ipsum).words(2) }
    f.description { Forgery(:lorem_ipsum).paragraph }
    f.date { Time.now + rand(6).week }
    f.start_time { Time.parse("#{rand(24)}:#{rand(60)}") }
    f.association :owner
  end

  factory :announcement do |f|
    f.subject { Forgery(:lorem_ipsum).words(2) }
    f.body { Forgery(:lorem_ipsum).paragraph }
    f.association :feed
  end

  factory :feed do |f|
    f.name { Forgery(:name).company_name }
    f.about { Forgery(:basic).text }
  end
  
  factory :message do |f|
    f.association :user
    f.association :recipient, :factory => :user
    f.subject { Forgery(:lorem_ipsum).words(2) }
    f.body { Forgery(:lorem_ipsum).sentence }
  end

  factory :referral do |f|
    f.association :event
    f.association :referee, :factory => :user
    f.association :referrer, :factory => :user
  end

  factory :transaction do |f|
    f.association :community
    f.association :owner, factory: :user
  end
end
