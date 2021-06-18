class SubscriptionsController < ApplicationController

  before_action :load_question, only: [:create, :destroy]

  authorize_resource

  def create
    @subscribe = Subscription.find_by(user_id: current_user&.id)
    @question.subscriptions.create!(user: current_user)
    render json: { question_id: @question.id }
  end

  def destroy
    @subscribe = Subscription.find_by(user_id: current_user&.id)  
    @subscribe.destroy
    render json: { question_id: @question.id }
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end
