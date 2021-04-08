class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :reward_title, :image, presence: true
end
