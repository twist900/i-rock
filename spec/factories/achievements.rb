FactoryGirl.define do
  factory :achievement do
    sequence(:title) {|n| "Achievement title #{n}"}
    description "Description"
    featured false
    cover_image "cover_image.jpg"
	  
	  factory :public_achievement do
	  	privacy :public_access
	  end

	  factory :private_achievement do
	  	privacy :private_access
	  end
	end
end

