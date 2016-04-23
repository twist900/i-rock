FactoryGirl.define do
  factory :user do
  	sequence(:email){|num| "email#{num}@example.com"}
  	password "passwordpassword"
  end
end
