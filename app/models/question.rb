class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_one :reward, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def rating
    self.votes.pluck(:value).sum
  end

  def vote(user, vote_value)
    votes.create!(user_id: user.id, value: vote_value)
  end

  def cancel_vote(user)
    votes.find_by(user_id: user).destroy
  end
end
