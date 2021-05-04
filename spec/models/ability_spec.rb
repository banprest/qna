require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user}
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other}

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Link }
    it { should be_able_to :create, Reward }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, user: user, question: question) }
    it { should_not be_able_to :update, create(:answer, user: other, question: question) }

    it { should be_able_to :update, create(:comment, user: user, commentable: question) }
    it { should_not be_able_to :update, create(:comment, user: other, commentable: question) } 

    it { should be_able_to :update, create(:link, linkable: question) }
    it { should_not be_able_to :update, create(:link, linkable: other_question) }

    it { should be_able_to :update, create(:reward, question: question) }
    it { should_not be_able_to :update, create(:reward, question: other_question) }

    it { should be_able_to :best, create(:answer, user: other, question: question) }
    it { should_not be_able_to :best, create(:answer, user: other, question: other_question) }      

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user, question: question) }
    it { should_not be_able_to :destroy, create(:answer, user: other, question: question) }

    it { should be_able_to :destroy, create(:comment, user: user, commentable: question) }
    it { should_not be_able_to :destroy, create(:comment, user: other, commentable: question) }        

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it { should be_able_to :destroy, create(:reward, question: question) }
    it { should_not be_able_to :destroy, create(:reward, question: other_question) }


    it { should_not be_able_to :vote_up, question }
    it { should_not be_able_to :vote_down, question }
    it { should_not be_able_to :cancel_vote, question }
    it { should be_able_to :vote_up, create(:question, user: other) }
    it { should be_able_to :vote_down, other_question }
    it { should be_able_to :cancel_vote, other_question }


  end
end
