class Achievement < ActiveRecord::Base
	belongs_to :user

  validates :title, presence: true
  validate :unique_title_for_one_user
  # validates :title, uniqueness: true

	enum privacy: [:public_access, :private_access, :friend_access]

  private

  def unique_title_for_one_user
    existing_achievement = Achievement.find_by(title: title)
    if existing_achievement && existing_achievement.user == user
      errors.add(:title, 'This title already exists')
    end
  end
end
