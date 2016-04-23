require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'validations' do
    it 'requires title' do
      achievement = Achievement.new(title: '')
      achievement.valid?
      expect(achievement.errors[:title]).to include("can't be blank")
    end

    it 'requires title to be unique for one user' do
      user = FactoryGirl.create(:user)
      some_achievement = FactoryGirl.create(:public_achievement, title: 'My Achievement', user: user)
      new_achievement = Achievement.new(title: 'My Achievement', user: user)
      expect(new_achievement.valid?).to be_falsy
    end

    it 'allows to have same titles for different users' do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      user1_achievement = FactoryGirl.create(:public_achievement, title: 'My Achievement', user: user1)
      user2_achievement = Achievement.new(title: 'My Achievement', user: user2 )
      expect(user2_achievement.valid?).to be_truthy
    end
  end

  it 'belongs to user' do
    achievement = Achievement.new(title: 'Some title', user: nil)
    expect(achievement.valid?).to be_falsy
  end

  it 'has belongs_to user association' do
    user = FactoryGirl.create(:user)
    achievement = FactoryGirl.create(:public_achievement, user: user)
    expect(achievement.user).to eq(user)
  end
end
