module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable    
  end

  def rating
    votes.sum(:value)
  end

  def vote(user, vote_value)
    votes.create!(user_id: user.id, value: vote_value)
  end

  def cancel_vote(user)
    votes.find_by(user_id: user).destroy
  end
end
