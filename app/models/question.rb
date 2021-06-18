class Question < ApplicationRecord
  include Votable
  include Commentable
  
  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  def subscribed?(user)
    subscriptions.exists?(user_id: user)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
