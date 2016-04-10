require 'rails_helper'

feature 'achievement page' do
	scenario 'achievement public page' do
		achievement = FactoryGirl.create(:achievement, title: 'Just did it')
		visit("/achievements/#{achievement.id}")

		expect(page).to have_content('Just did it')
	end
end