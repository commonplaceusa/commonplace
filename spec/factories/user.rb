FactoryGirl.define do
  factory :neighborhood do
    sequence(:name) { |n| "Neighborhood#{n}"}
    bounds [[0,0],[0,0]]
    latitude 0.0
    longitude 0.0
    community_id 1
  end
  factory :community do
    name "Test Community"
    slug "testCommunity"
    after_build { |community|
      community.neighborhoods << Factory.build(:neighborhood, :community => community)
    }
  end
  factory :user do
    community
    sequence(:first_name) { |n| "User#{n}" }
    sequence(:last_name) { |n| "Doe#{n}" }
    sequence(:address) { |n| "#{n} Any Lane"}
    password "foobar"
    email { "#{first_name}@example.com" }
    admin false
    factory :admin do
      admin true
    end
  end
end
