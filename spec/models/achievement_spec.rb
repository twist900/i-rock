require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).scoped_to(:user_id)
      .with_message("you can't have two achievements with the same title")}
    it { should validate_presence_of(:user)}
    it { should belong_to(:user)}
  end

  it 'converts markdown to html' do
    achievement = Achievement.new(description: 'Awesome **thing** I *actually* did')
    expect(achievement.description_html).to include('<strong>thing</strong>')
  end

  it 'prints silly title' do
    achievement = Achievement.new(title: 'New Achievement',
      user: FactoryGirl.create(:user, email: 'test@test.com'))
    expect(achievement.silly_title).to eq("New Achievement by test@test.com")
  end

  it 'fetches only those achievements that start from a given letter' do
    user = FactoryGirl.create(:user)
    achievement1 = FactoryGirl.create(:public_achievement, title: 'Roll your sleeves', user: user)
    achievement2 = FactoryGirl.create(:public_achievement, title: 'My achievement', user: user)
    expect(Achievement.by_letter('R')).to eq([achievement1])
  end

  it 'orders achievements by user email' do
    albert = FactoryGirl.create(:user, email: 'albert@email.com')
    rob = FactoryGirl.create(:user, email: 'rob@email.com')
    achievement1 = FactoryGirl.create(:public_achievement, title: 'New achievement', user: rob)
    achievement2 = FactoryGirl.create(:public_achievement, title: 'New achievement', user: albert)
    expect(Achievement.by_letter('N')).to eq([achievement2, achievement1])
  end
end
