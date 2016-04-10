FactoryGirl.define do
  factory :achievement do
    sequence(:title) {|n| "Achievement title #{n}"}
    description "Description"
    privacy Achievement.privacies[:private_achievement]
    featured false
    cover_image "cover_image.jpg"
  end

  factory :public_achievement do
  	privacy Achievement.privacies[:public_achievement]
  end
end

