# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :search, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User
    can :create, [Question, Answer, Comment, Link, Reward, Subscription]
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :best, Answer, question: { user_id: user.id }
    can :update, [Question, Answer, Comment], user_id: user.id
    can :update, [Link], linkable: { user_id: user.id }
    can :update, [Reward], question: { user_id: user.id } 
    can :destroy, [Link], linkable: { user_id: user.id }
    can :destroy, [Reward], question: { user_id: user.id }
    can :vote_up, [Question, Answer] do |votable|
      !user.author?(votable)
    end 
    can :vote_down, [Question, Answer] do |votable|
      !user.author?(votable)
    end 
    can :cancel_vote, [Question, Answer] do |votable|
      !user.author?(votable)
    end 
    
    can :destroy, Subscription do |question|
      question.subscribed?(user)
    end
  end
end
